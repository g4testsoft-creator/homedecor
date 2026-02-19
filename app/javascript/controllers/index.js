// app/javascript/controllers/index.js
import { application } from "./application"
import ReviewsSubscriptionController from "./reviews_subscription_controller"

application.register("reviews-subscription", ReviewsSubscriptionController)