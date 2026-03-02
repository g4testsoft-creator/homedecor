// app/javascript/controllers/reviews_subscription_controller.js
import { Controller } from "@hotwired/stimulus"
import * as ActionCable from "@rails/actioncable"

export default class extends Controller {
  static values = { decorItemId: Number }
  static targets = ["reviewsList", "ratingDisplay", "noReviewsMessage"]

  connect() {
    this.consumer = ActionCable.createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: "ReviewsChannel",
        decor_item_id: this.decorItemIdValue
      },
      {
        received: this.handleReceived.bind(this)
      }
    )
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
    
    if (data.action === "create") {
      this.addReview(data.render_review)
      this.updateRating(data.render_rating)
      this.hideNoReviewsMessage()
    }
  }

  addReview(html) {
    // Insert the new review at the top of the list
    if (this.hasReviewsListTarget) {
      this.reviewsListTarget.insertAdjacentHTML('afterbegin', html)
    } else {
    }
  }

  updateRating(html) {
    if (this.hasRatingDisplayTarget) {
      this.ratingDisplayTarget.innerHTML = html
    } else {
    }
  }

  hideNoReviewsMessage() {
    if (this.hasNoReviewsMessageTarget) {
      this.noReviewsMessageTarget.style.display = 'none'
    }
  }
}