import * as ActionCable from "@rails/actioncable"

export function createConsumer(url = defaultWebSocketURL) {
  return ActionCable.createConsumer(url)
}

function defaultWebSocketURL() {
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  return `${protocol}//${window.location.host}/cable`
}
