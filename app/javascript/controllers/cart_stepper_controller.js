import { Controller } from "@hotwired/stimulus"

// Drives the +/- stepper on the cart page. Sends a Turbo Stream PATCH so that
// the server can replace the line items list, the navbar cart count, and the
// totals block in one round trip.
export default class extends Controller {
  static targets = ["incrementButton", "decrementButton", "quantity"]

  static values = {
    productId: Number,
    quantity: { type: Number, default: 1 },
    updateUrl: String,
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

    const formData = new FormData()
    formData.append("product_id", this.productIdValue)
    formData.append("quantity", target)

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": this.csrfToken,
        Accept: "text/vnd.turbo-stream.html",
      },
      body: formData,
      credentials: "same-origin",
    })
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.text()
      })
      .then((html) => {
        if (window.Turbo && typeof window.Turbo.renderStreamMessage === "function") {
          window.Turbo.renderStreamMessage(html)
        }
      })
      .catch((err) => {
        console.error("Cart update error:", err)
        this.setBusy(false)
      })
  }

  setBusy(value) {
    this.isBusy = value
    if (this.hasIncrementButtonTarget) this.incrementButtonTarget.disabled = value
    if (this.hasDecrementButtonTarget) this.decrementButtonTarget.disabled = value
  }

  get csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ""
  }
}
