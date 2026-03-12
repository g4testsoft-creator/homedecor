import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product-gallery"
export default class extends Controller {
  static targets = ["mainImage", "thumbnail"]

  connect() {
    // this.setActiveThumbnail(this.thumbnailTargets[0])
  }

  select(event) {
    event.preventDefault()
    const selectedThumb = event.currentTarget
    console.log("Selected thumbnail:", selectedThumb)
    const imageUrl = selectedThumb.dataset.imageUrl
    const imageAlt = selectedThumb.dataset.imageAlt

    // Update main image src and alt
    if (imageUrl) {
      this.mainImageTarget.src = imageUrl
    }
    if (imageAlt) {
      this.mainImageTarget.alt = imageAlt
    }

    // Update active state on thumbnails
    this.setActiveThumbnail(selectedThumb)
  }

  setActiveThumbnail(activeThumb) {
    this.thumbnailTargets.forEach(thumb => {
      thumb.classList.remove('active-thumbnail')
    })
    if (activeThumb) {
      activeThumb.classList.add('active-thumbnail')
    }
  }
}