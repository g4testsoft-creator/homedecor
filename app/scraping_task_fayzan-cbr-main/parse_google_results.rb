require 'json'
require 'nokogiri'
require 'yaml'

input_path  = ARGV[0] || 'google_pet_brands.html'
output_path = ARGV[1] || 'output.json'

root_dir   = File.dirname(__FILE__)
config_dir = File.join(root_dir, 'config')
config_path = File.join(config_dir, 'extraction.yml')

config =
  if File.exist?(config_path)
    YAML.load_file(config_path) || {}
  else
    {}
  end

config_key      = File.basename(input_path, File.extname(input_path))
file_config     = config[config_key] || {}
configured_fields = (file_config['fields'] || %w[title link snippet thumbnail]).map(&:to_s)

html = File.read(input_path)
doc  = Nokogiri::HTML(html)

image_map = {}

def extract_image_map_from_scripts(doc)
  image_map = {}
  
  doc.css('script').each do |script|
    text = script.text
    
    # Extract from google.ldi scripts
    extract_from_ldi_script(text, image_map)
    
    # Extract from image src scripts
    extract_from_image_src_script(text, image_map)
  end
  
  image_map
end

def extract_from_ldi_script(text, image_map)
  return unless text.include?('google.ldi')
  
  text.scan(/google\.ldi\s*=\s*(\{.*?\})\s*;/m).each do |match|
    json_like = match.first
    begin
      parsed = JSON.parse(json_like)
      parsed.each do |key, url|
        next unless key.start_with?('dimg_')
        image_map[key] = url
      end
    rescue JSON::ParserError
      # Silently ignore parsing errors
    end
  end
end

def extract_from_image_src_script(text, image_map)
  text.scan(/var\s+s\s*=\s*'(data:image\/jpeg;base64,[^']+)';\s*var\s+ii\s*=\s*\[([^\]]+)\];\s*_setImagesSrc\(\s*ii\s*,\s*s\s*\)/m).each do |base64, ids_str|
    fixed_base64 = base64.gsub('\\x3d', '=')
    ids = ids_str.scan(/'([^']+)'/).flatten
    ids.each do |id|
      next unless id.start_with?('dimg_')
      image_map[id] ||= fixed_base64
    end
  end
end

image_map = extract_image_map_from_scripts(doc)

results = []

organic_nodes = doc.css('div#search div.g')

organic_nodes = doc.css('div.g') if organic_nodes.empty?

organic_nodes.each do |node|
  snippet_node = node.at_css('div.VwiC3b, div.IsZvec')
  next unless snippet_node

  link_node = node.at_css('div.yuRUbf a[href]') || node.at_css('a[href]')
  next unless link_node

  title_node = link_node.at_css('h3') || node.at_css('h3')
  next unless title_node

  title   = title_node.text.strip
  link    = link_node['href']
  snippet = snippet_node.text.gsub(/\s+/, ' ').strip
  snippet = snippet.sub(/^[A-Z][a-z]{2,8} \d{1,2}, \d{4}\s+—\s+/, '')

  next if title.empty? || link.nil? || link.empty?

  result = {}
  result['title']   = title   if configured_fields.include?('title')
  result['link']    = link    if configured_fields.include?('link')
  result['snippet'] = snippet if configured_fields.include?('snippet')

  if configured_fields.include?('thumbnail')
    img = node.at_css('div.kb0PBd.cvP2Ce.LnCrMe img[id^="dimg_"]') 
    if img
      image_id = img['id']
      thumbnail = image_map[image_id] if image_id
      result['thumbnail'] = thumbnail if thumbnail
    end
  end

  results << result
end

output = {
  'organic_results' => results
}

File.write(output_path, JSON.pretty_generate(output))
