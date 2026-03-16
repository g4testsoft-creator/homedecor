// app/javascript/controllers/categories_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    this.isOpen = false
    
    // Close menu when clicking outside
    document.addEventListener("click", (event) => {
      if (!this.element.contains(event.target)) {
        this.close()
      }
    })
  }
  
  toggle() {
    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  }
  
  open() {
    this.menuTarget.classList.add("show")
    this.isOpen = true
  }
  
  close() {
    // this.menuTarget.classList.remove("show")
    this.isOpen = false
  }
}
