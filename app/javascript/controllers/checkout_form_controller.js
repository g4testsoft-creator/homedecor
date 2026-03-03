import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "submitBtn"]

  connect() {
    this.checkFormValidity()
    // Add event listeners to all field targets
    this.fieldTargets.forEach(field => {
      field.addEventListener("input", () => this.checkFormValidity())
      field.addEventListener("change", () => this.checkFormValidity())
    })
  }

  checkFormValidity() {
    const allFieldsFilled = this.fieldTargets.every(field => {
      return field.value.trim() !== ""
    })

    if (allFieldsFilled) {
      this.submitBtnTarget.disabled = false
      this.submitBtnTarget.classList.remove("btn-disabled")
    } else {
      this.submitBtnTarget.disabled = true
      this.submitBtnTarget.classList.add("btn-disabled")
    }
  }
}
