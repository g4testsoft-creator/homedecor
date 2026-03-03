import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    console.log("Toast controller connected")
  }

  showToast(message, type = "success", duration = 3000) {
    console.log("Showing toast", message, type, duration)
    const toast = document.createElement("div")
    toast.className = `toast toast-${type}`
    toast.innerHTML = `
      <div class="toast-content">
        <span class="toast-message">${message}</span>
        <button class="toast-close" data-action="click->toast#closeToast">×</button>
      </div>
    `

    // Insert at the top of notifications container
    const container = document.querySelector(".toast-container") || this.createContainer()
    container.appendChild(toast)

    // Auto remove after duration
    setTimeout(() => {
      console.log("Removing toast")
      toast.classList.add("toast-fade-out")
      setTimeout(() => toast.remove(), 3000)
    }, duration)

    return toast
  }

  createContainer() {
    const container = document.createElement("div")
    container.className = "toast-container"
    document.body.appendChild(container)
    return container
  }

  closeToast(event) {
    const toast = event.target.closest(".toast")
    toast.classList.add("toast-fade-out")
    setTimeout(() => toast.remove(), 300)
  }
}
