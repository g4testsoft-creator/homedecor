import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar", "overlay", "toggle"]

  connect() {
    // Close sidebar when clicking on nav links
    this.handleNavLinkClick = this.handleNavLinkClick.bind(this)
    this.addNavLinkListeners()
  }

  toggle(event) {
    event.preventDefault()
    
    if (this.isOpen()) {
      this.closeSidebar()
    } else {
      this.openSidebar()
    }
  }

  close(event) {
    event?.preventDefault()
    this.closeSidebar()
  }

  open(event) {
    event?.preventDefault()
    this.openSidebar()
  }

  handleNavLinkClick() {
    // Close sidebar when a category link is clicked
    this.closeSidebar()
  }

  addNavLinkListeners() {
    const navLinks = this.sidebarTarget.querySelectorAll(".sidebar-nav-link")
    navLinks.forEach(link => {
      link.addEventListener("click", this.handleNavLinkClick)
    })
  }

  isOpen() {
    return this.sidebarTarget.classList.contains("open")
  }

  openSidebar() {
    this.sidebarTarget.classList.add("open")
    this.overlayTarget.classList.add("open")
    this.toggleTarget.classList.add("active")
    document.body.classList.add("sidebar-open")
  }

  closeSidebar() {
    this.sidebarTarget.classList.remove("open")
    this.overlayTarget.classList.remove("open")
    this.toggleTarget.classList.remove("active")
    document.body.classList.remove("sidebar-open")
  }

  disconnect() {
    const navLinks = this.sidebarTarget.querySelectorAll(".sidebar-nav-link")
    navLinks.forEach(link => {
      link.removeEventListener("click", this.handleNavLinkClick)
    })
  }
}
