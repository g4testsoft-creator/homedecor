// app/javascript/controllers/reviews_subscription_controller.js
import { Controller } from "@hotwired/stimulus"
import * as ActionCable from "@rails/actioncable"

export default class extends Controller {
  static values = { productId: Number }
  static targets = ["reviewsList", "ratingDisplay", "noReviewsMessage"]

  connect() {
    console.log("[ReviewsSubscription] Connecting with product_id:", this.productIdValue)
    this.consumer = ActionCable.createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: "ReviewsChannel",
        product_id: this.productIdValue
      },
      {
        connected: this.handleConnected.bind(this),
        disconnected: this.handleDisconnected.bind(this),
        received: this.handleReceived.bind(this),
        rejected: this.handleRejected.bind(this)
      }
    )
  }

  handleConnected() {
    console.log("[ReviewsSubscription] Connected to ReviewsChannel")
  }

  handleDisconnected() {
    console.log("[ReviewsSubscription] Disconnected from ReviewsChannel")
  }

  handleRejected() {
    console.log("[ReviewsSubscription] Connection rejected")
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
    
    if (this.consumer) {
      this.consumer.disconnect()
    }
  }

  handleReceived(data) {
    console.log("[ReviewsSubscription] Data received:", data)
    if (data.action === "create") {
      console.log("[ReviewsSubscription] Adding new review")
      this.addReview(data.render_review)
      console.log("[ReviewsSubscription] Updating rating")
      this.updateRating(data.render_rating)
      console.log("[ReviewsSubscription] Hiding no reviews message")
      this.hideNoReviewsMessage()
    }
  }

  addReview(html) {
    // Insert the new review at the top of the list
    console.log("[ReviewsSubscription] Has reviewsList target:", this.hasReviewsListTarget)
    if (this.hasReviewsListTarget) {
      console.log("[ReviewsSubscription] Inserting review HTML")
      this.reviewsListTarget.insertAdjacentHTML('afterbegin', html)
    } else {
      console.warn("[ReviewsSubscription] reviewsList target not found")
    }
  }

  updateRating(html) {
    console.log("[ReviewsSubscription] Has ratingDisplay target:", this.hasRatingDisplayTarget)
    if (this.hasRatingDisplayTarget) {
      console.log("[ReviewsSubscription] Updating rating display")
      this.ratingDisplayTarget.innerHTML = html
    } else {
      console.warn("[ReviewsSubscription] ratingDisplay target not found")
    }
  }

  hideNoReviewsMessage() {
    console.log("[ReviewsSubscription] Has noReviewsMessage target:", this.hasNoReviewsMessageTarget)
    if (this.hasNoReviewsMessageTarget) {
      console.log("[ReviewsSubscription] Hiding no reviews message")
      this.noReviewsMessageTarget.style.display = 'none'
    } else {
      console.warn("[ReviewsSubscription] noReviewsMessage target not found")
    }
  }
}