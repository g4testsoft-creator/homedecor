require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:category).optional }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
