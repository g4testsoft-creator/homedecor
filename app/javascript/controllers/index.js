// app/javascript/controllers/index.js
import { application } from "controllers/application"  // ✅ goes through importmap
import ReviewsSubscriptionController from "controllers/reviews_subscription_controller"

application.register("reviews-subscription", ReviewsSubscriptionController)