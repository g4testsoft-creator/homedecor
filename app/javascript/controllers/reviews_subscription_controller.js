// app/javascript/controllers/reviews_subscription_controller.js
import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "../channels/consumer"

export default class extends Controller {
  static values = { decorItemId: Number }
  static targets = ["reviewsList", "ratingDisplay", "noReviewsMessage"]

  connect() {
    console.log('[JS] ReviewsSubscriptionController connecting')
    this.consumer = createConsumer()    
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: "ReviewsChannel",
        decor_item_id: this.decorItemIdValue
      },
      {
        received: this.handleReceived.bind(this)
      }
    )
    console.log('[JS] Subscribed to ReviewsChannel with decor_item_id:', this.decorItemIdValue)
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
    console.log('[JS] Received data:', data)
    console.log('[JS] Data action:', data.action)
    
    if (data.action === "create") {
      console.log('[JS] Adding new review to the list')
      this.addReview(data.render_review)
      console.log('[JS] Updating rating display')
      this.updateRating(data.render_rating)
      console.log('[JS] Hiding no reviews message')
      this.hideNoReviewsMessage()
    }
  }

  addReview(html) {
    console.log('[JS] addReview called with html length:', html.length)
    // Insert the new review at the top of the list
    if (this.hasReviewsListTarget) {
      console.log('[JS] Found reviewsList target, inserting review')
      this.reviewsListTarget.insertAdjacentHTML('afterbegin', html)
    } else {
      console.error('[JS] reviewsList target not found!')
    }
  }

  updateRating(html) {
    console.log('[JS] updateRating called with html length:', html.length)
    if (this.hasRatingDisplayTarget) {
      console.log('[JS] Found ratingDisplay target, updating')
      this.ratingDisplayTarget.innerHTML = html
    } else {
      console.error('[JS] ratingDisplay target not found!')
    }
  }

  hideNoReviewsMessage() {
    console.log('[JS] hideNoReviewsMessage called')
    if (this.hasNoReviewsMessageTarget) {
      console.log('[JS] Hiding no reviews message')
      this.noReviewsMessageTarget.style.display = 'none'
    }
  }
}