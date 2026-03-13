import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "desktopInput", "desktopDropdown", "desktopContainer",
    "mobileInput", "mobileDropdown", "mobileContainer"
  ]
  
  connect() {
    this.timeout = null
    this.selectedIndex = -1
    this.results = []
    this.currentDevice = window.innerWidth <= 768 ? 'mobile' : 'desktop'
    
    // Handle resize events
    window.addEventListener('resize', () => {
      this.currentDevice = window.innerWidth <= 768 ? 'mobile' : 'desktop'
    })
    
    // Close dropdown when clicking outside
    document.addEventListener("click", (event) => {
      if (this.hasDesktopContainer && !this.desktopContainerTarget.contains(event.target)) {
        this.hideDropdown('desktop')
      }
      if (this.hasMobileContainer && !this.mobileContainerTarget.contains(event.target)) {
        this.hideDropdown('mobile')
      }
    })
    
    // Keyboard navigation for desktop
    if (this.hasDesktopInput) {
      this.desktopInputTarget.addEventListener("keydown", (event) => {
        if (event.key === "ArrowDown") {
          event.preventDefault()
          this.selectNext('desktop')
        } else if (event.key === "ArrowUp") {
          event.preventDefault()
          this.selectPrevious('desktop')
        } else if (event.key === "Escape") {
          this.hideDropdown('desktop')
        }
      })
    }
    
    // Keyboard navigation for mobile
    if (this.hasMobileInput) {
      this.mobileInputTarget.addEventListener("keydown", (event) => {
        if (event.key === "ArrowDown") {
          event.preventDefault()
          this.selectNext('mobile')
        } else if (event.key === "ArrowUp") {
          event.preventDefault()
          this.selectPrevious('mobile')
        } else if (event.key === "Escape") {
          this.hideDropdown('mobile')
        }
      })
    }
  }
  
  // Desktop search
  desktopSearch() {
    this.search('desktop')
  }
  
  // Mobile search
  mobileSearch() {
    this.search('mobile')
  }
  
  search(device) {
    clearTimeout(this.timeout)
    const input = device === 'desktop' ? this.desktopInputTarget : this.mobileInputTarget
    const query = input.value.trim()
    
    if (query.length < 2) {
      this.hideDropdown(device)
      return
    }
    
    this.showLoading(device)
    
    this.timeout = setTimeout(() => {
      fetch(`/products/search?q=${encodeURIComponent(query)}`, {
        headers: {
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then(data => {
        this.results = data
        this.displayResults(data, device)
      })
      .catch(error => {
        console.error("Search error:", error)
        this.showError(device)
      })
    }, 300)
  }
  
  displayResults(products, device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    
    if (products.length === 0) {
      dropdown.innerHTML = '<div class="search-no-results">No products found</div>'
      dropdown.classList.add("show")
      return
    }
    
    const html = products.map((product, index) => `
      <a href="/products/${product.id}" class="search-dropdown-item" data-index="${index}">
        <h4>${this.escapeHtml(product.name)}</h4>
        ${product.price ? `<p>$${product.price}</p>` : ''}
      </a>
    `).join("")
    
    dropdown.innerHTML = html
    dropdown.classList.add("show")
    this.selectedIndex = -1
  }
  
  showLoading(device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    dropdown.innerHTML = '<div class="search-loading">Searching...</div>'
    dropdown.classList.add("show")
  }
  
  showError(device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    dropdown.innerHTML = '<div class="search-no-results">Error searching products</div>'
    dropdown.classList.add("show")
  }
  
  hideDropdown(device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    dropdown.classList.remove("show")
    this.selectedIndex = -1
  }
  
  selectNext(device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    const items = dropdown.querySelectorAll(".search-dropdown-item")
    if (items.length === 0) return
    
    this.selectedIndex = (this.selectedIndex + 1) % items.length
    this.highlightItem(items)
  }
  
  selectPrevious(device) {
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    const items = dropdown.querySelectorAll(".search-dropdown-item")
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
  
  // Desktop submit
  desktopSubmit(event) {
    this.submitSearch(event, 'desktop')
  }
  
  // Mobile submit
  mobileSubmit(event) {
    this.submitSearch(event, 'mobile')
  }
  
  submitSearch(event, device) {
    event.preventDefault()
    const input = device === 'desktop' ? this.desktopInputTarget : this.mobileInputTarget
    const dropdown = device === 'desktop' ? this.desktopDropdownTarget : this.mobileDropdownTarget
    const query = input.value.trim()
    
    if (this.selectedIndex >= 0) {
      // Navigate to selected product
      const selectedItem = dropdown.querySelectorAll(".search-dropdown-item")[this.selectedIndex]
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