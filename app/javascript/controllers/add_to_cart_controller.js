import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["addButton", "stepper", "quantity", "incrementButton", "decrementButton"]

  static values = {
    productId: Number,
    productName: String,
    quantity: { type: Number, default: 0 },
    addUrl: String,
    updateUrl: String,
  }

  connect() {
    this.boundExternalUpdate = this.handleExternalUpdate.bind(this)
    document.addEventListener("cart:product-updated", this.boundExternalUpdate)
  }

  disconnect() {
    document.removeEventListener("cart:product-updated", this.boundExternalUpdate)
  }

  add(event) {
    event.preventDefault()
    if (this.isBusy) return
    this.setBusy(true)

    this.sendRequest("POST", this.addUrlValue, { product_id: this.productIdValue, quantity: 1 })
      .then((data) => {
        if (data && data.success) {
          const newQty = Number(data.product_quantity_in_cart) || 1
          this.applyQuantity(newQty)
          this.broadcast(newQty)
          this.updateCartCountBadge(data.cart_total_items)
          this.showNotification(`${this.productNameValue} added to cart`, "success")
        } else {
          this.showNotification("Failed to add item to cart", "error")
        }
      })
      .catch((err) => {
        console.error("Error adding to cart:", err)
        this.showNotification("An error occurred while adding to cart", "error")
      })
      .finally(() => this.setBusy(false))
  }

  increment(event) {
    event.preventDefault()
    if (this.isBusy) return
    this.changeQuantity(this.quantityValue + 1)
  }

  decrement(event) {
    event.preventDefault()
    if (this.isBusy) return
    this.changeQuantity(this.quantityValue - 1)
  }

  changeQuantity(newQty) {
    const target = Math.max(0, newQty)
    this.setBusy(true)

    this.requestQuantityUpdate(target)
      .then((data) => {
        if (data && data.success) {
          const finalQty = Number(data.product_quantity_in_cart) || 0
          this.applyQuantity(finalQty)
          this.broadcast(finalQty)
          this.updateCartCountBadge(data.cart_total_items)
        } else {
          this.showNotification("Failed to update cart", "error")
        }
      })
      .catch((err) => {
        console.error("Error updating cart:", err)
        this.showNotification("An error occurred while updating cart", "error")
      })
      .finally(() => this.setBusy(false))
  }

  requestQuantityUpdate(quantity) {
    return this.sendRequest("PATCH", this.updateUrlValue, {
      product_id: this.productIdValue,
      quantity,
    })
  }

  sendRequest(method, url, payload) {
    const formData = new FormData()
    Object.entries(payload).forEach(([key, value]) => {
      formData.append(key, value)
    })

    return fetch(url, {
      method,
      headers: {
        "X-CSRF-Token": this.csrfToken,
        Accept: "application/json",
      },
      body: formData,
      credentials: "same-origin",
    }).then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }
      return response.json()
    })
  }

  applyQuantity(quantity) {
    this.quantityValue = quantity
    if (this.hasQuantityTarget) {
      this.quantityTarget.textContent = Math.max(quantity, 1)
    }

    if (quantity <= 0) {
      this.showAddButton()
    } else {
      this.showStepper()
    }
  }

  showAddButton() {
    if (this.hasAddButtonTarget) this.addButtonTarget.hidden = false
    if (this.hasStepperTarget) this.stepperTarget.hidden = true
  }

  showStepper() {
    if (this.hasAddButtonTarget) this.addButtonTarget.hidden = true
    if (this.hasStepperTarget) this.stepperTarget.hidden = false
  }

  broadcast(quantity) {
    document.dispatchEvent(
      new CustomEvent("cart:product-updated", {
        detail: {
          productId: this.productIdValue,
          quantity,
          source: this.element,
        },
      })
    )
  }

  handleExternalUpdate(event) {
    const { productId, quantity, source } = event.detail || {}
    if (!productId || productId !== this.productIdValue) return
    if (source === this.element) return
    this.applyQuantity(quantity)
  }

  updateCartCountBadge(total) {
    if (typeof total === "undefined" || total === null) return
    const numeric = Number(total)
    const link = document.querySelector(".cart-link")
    if (!link) return

    let badge = link.querySelector(".cart-count")

    if (numeric > 0) {
      if (!badge) {
        badge = document.createElement("span")
        badge.className = "cart-count"
        link.appendChild(badge)
      }
      badge.textContent = numeric
    } else if (badge) {
      badge.remove()
    }
  }

  setBusy(value) {
    this.isBusy = value
    if (this.hasIncrementButtonTarget) this.incrementButtonTarget.disabled = value
    if (this.hasDecrementButtonTarget) this.decrementButtonTarget.disabled = value
    if (this.hasAddButtonTarget && !this.addButtonTarget.hasAttribute("data-permanently-disabled")) {
      this.addButtonTarget.disabled = value
    }
  }

  get csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ""
  }

  showNotification(message, type = "success") {
    let container = document.querySelector(".toast-container")
    if (!container) {
      container = document.createElement("div")
      container.className = "toast-container"
      document.body.appendChild(container)
    }

    const toast = document.createElement("div")
    toast.className = `toast toast-${type}`
    toast.innerHTML = `
      <div class="toast-content">
        <span class="toast-message">${message}</span>
        <button class="toast-close" data-action="click->add-to-cart#closeToast">×</button>
      </div>
    `

    container.appendChild(toast)

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
