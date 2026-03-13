import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "container"]
  
  connect() {
    this.timeout = null
    this.selectedIndex = -1
    this.results = []
    
    // Close dropdown when clicking outside
    document.addEventListener("click", (event) => {
      if (!this.containerTarget.contains(event.target)) {
        this.hideDropdown()
      }
    })
    
    // Keyboard navigation
    this.inputTarget.addEventListener("keydown", (event) => {
      if (event.key === "ArrowDown") {
        event.preventDefault()
        this.selectNext()
      } else if (event.key === "ArrowUp") {
        event.preventDefault()
        this.selectPrevious()
      } else if (event.key === "Escape") {
        this.hideDropdown()
      }
    })
  }
  
  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.hideDropdown()
      return
    }
    
    this.showLoading()
    
    this.timeout = setTimeout(() => {
      fetch(`/products/search?q=${encodeURIComponent(query)}`, {
        headers: {
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then(data => {
        this.results = data
        this.displayResults(data)
      })
      .catch(error => {
        console.error("Search error:", error)
        this.showError()
      })
    }, 300)
  }
  
  displayResults(products) {
    if (products.length === 0) {
      this.dropdownTarget.innerHTML = '<div class="search-no-results">No products found</div>'
      this.dropdownTarget.classList.add("show")
      return
    }
    
    const html = products.map((product, index) => `
      <a href="/products/${product.id}" class="search-dropdown-item" data-index="${index}">
        <h4>${this.escapeHtml(product.name)}</h4>
        ${product.price ? `<p>$${product.price}</p>` : ''}
      </a>
    `).join("")
    
    this.dropdownTarget.innerHTML = html
    this.dropdownTarget.classList.add("show")
    this.selectedIndex = -1
  }
  
  showLoading() {
    this.dropdownTarget.innerHTML = '<div class="search-loading">Searching...</div>'
    this.dropdownTarget.classList.add("show")
  }
  
  showError() {
    this.dropdownTarget.innerHTML = '<div class="search-no-results">Error searching products</div>'
    this.dropdownTarget.classList.add("show")
  }
  
  hideDropdown() {
    this.dropdownTarget.classList.remove("show")
    this.selectedIndex = -1
  }
  
  selectNext() {
    const items = this.dropdownTarget.querySelectorAll(".search-dropdown-item")
    if (items.length === 0) return
    
    this.selectedIndex = (this.selectedIndex + 1) % items.length
    this.highlightItem(items)
  }
  
  selectPrevious() {
    const items = this.dropdownTarget.querySelectorAll(".search-dropdown-item")
    if (items.length === 0) return
    
    this.selectedIndex = this.selectedIndex - 1
    if (this.selectedIndex < 0) {
      this.selectedIndex = items.length - 1
    }
    this.highlightItem(items)
  }
  
  highlightItem(items) {
    items.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.style.backgroundColor = "#f5f5f5"
        item.focus()
      } else {
        item.style.backgroundColor = ""
      }
    })
  }
  
  submitSearch(event) {
    event.preventDefault()
    const query = this.inputTarget.value.trim()
    
    if (this.selectedIndex >= 0) {
      // Navigate to selected product
      const selectedItem = this.dropdownTarget.querySelectorAll(".search-dropdown-item")[this.selectedIndex]
      if (selectedItem) {
        window.location.href = selectedItem.href
        return
      }
    }
    
    // Otherwise go to search results page
    if (query.length > 0) {
      window.location.href = `/search?q=${encodeURIComponent(query)}`
    }
  }
  
  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}