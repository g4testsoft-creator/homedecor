// app/javascript/controllers/index.js
import { application } from "controllers/application" 
import ReviewsSubscriptionController from "controllers/reviews_subscription_controller"
import ToastController from "controllers/toast_controller"
import AddToCartController from "controllers/add_to_cart_controller"
import ProductGalleryController from "controllers/product_gallery_controller"
import HelloController from "controllers/hello_controller"
import CheckoutFormController from "controllers/checkout_form_controller"
import SearchController from "controllers/search_controller"

application.register("reviews-subscription", ReviewsSubscriptionController)
application.register("toast", ToastController)
application.register("add-to-cart", AddToCartController)
application.register("product-gallery", ProductGalleryController)
application.register("hello", HelloController)
application.register("checkout-form", CheckoutFormController)
application.register("search", SearchController)
