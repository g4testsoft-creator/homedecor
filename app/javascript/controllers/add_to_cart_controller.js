import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("submit", (e) => this.submit(e))
  }

  async submit(event) {
    event.preventDefault()
    const form = this.element
    const formData = new FormData(form)
    const quantity = formData.get("quantity")

    try {
      const response = await fetch(form.action, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "application/json"
        },
        body: formData
      })

      const data = await response.json()
      
      if (data.success) {
        // Show toast notification
        const message = `item added to cart successfully`
        this.showNotification(message, "success")
        
        // Update cart count
        this.updateCartCount(parseInt(quantity))
      } else {
        this.showNotification("Failed to add item to cart", "error")
      }
    } catch (error) {
      console.error("Error adding to cart:", error)
      this.showNotification("An error occurred while adding to cart", "error")
    }
  }

  updateCartCount(quantity) {
    const cartCountElement = document.querySelector("#cart_count .cart-count")
    if (cartCountElement) {
      const currentCount = parseInt(cartCountElement.textContent) || 0
      const newCount = currentCount + quantity
      cartCountElement.textContent = newCount
    } else {
      // If cart count doesn't exist, create it
      const cartLink = document.querySelector(".cart-link")
      if (cartLink) {
        let countSpan = cartLink.querySelector(".cart-count")
        if (!countSpan) {
          countSpan = document.createElement("span")
          countSpan.className = "cart-count"
          cartLink.appendChild(countSpan)
        }
        countSpan.textContent = quantity
      }
    }
  }

  showNotification(message, type = "success") {
    console.log("Showing notification:", message, type)
    
    // Create or get toast container
    let container = document.querySelector(".toast-container")
    if (!container) {
      container = document.createElement("div")
      container.className = "toast-container"
      document.body.appendChild(container)
    }

    // Create toast element
    const toast = document.createElement("div")
    toast.className = `toast toast-${type}`
    toast.innerHTML = `
      <div class="toast-content">
        <span class="toast-message">${message}</span>
        <button class="toast-close" data-action="click->add-to-cart#closeToast">×</button>
      </div>
    `

    container.appendChild(toast)

    // Auto remove after 3 seconds
    setTimeout(() => {
      toast.classList.add("toast-fade-out")
      setTimeout(() => toast.remove(), 300)
    }, 3000)
  }

  closeToast(event) {
    const toast = event.target.closest(".toast")
    if (toast) {
      toast.classList.add("toast-fade-out")
      setTimeout(() => toast.remove(), 300)
    }
  }
}
