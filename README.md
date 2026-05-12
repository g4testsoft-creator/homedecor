# Homedecor

Rails storefront for home décor products: browse categories and products, manage a cart (signed-in users or guests via session), checkout with Stripe, and admin tooling via RailsAdmin.

## Stack

| Layer | Technology |
|-------|----------------|
| Runtime | Ruby **3.3.5** ([`.ruby-version`](.ruby-version)) |
| Framework | **Rails ~> 7.0** |
| Database | **PostgreSQL** |
| Frontend | **Hotwire** (Turbo + Stimulus), **importmap** |
| Auth | **Devise** |
| Payments | **Stripe** |
| Background jobs | **Sidekiq** (+ Redis) |
| Admin | **RailsAdmin** |

## Prerequisites

- Ruby 3.3.5 (e.g. rbenv, asdf, or RVM)
- PostgreSQL
- Redis (for Sidekiq / Action Cable as configured)
- Node is not required for the default asset pipeline beyond what Rails/importmap uses

## Setup

1. **Clone and install gems**

   ```bash
   bundle install
   ```

2. **Environment**

   Copy `.env.example` to `.env` (or export vars yourself) and fill in values:

   - Database password (`HOMEDECOR_DATABASE_PASSWORD` or adjust [`config/database.yml`](config/database.yml))
   - `SECRET_KEY_BASE` (production)
   - `REDIS_URL`
   - Stripe keys if testing checkout
   - Optional: WhatsApp number (`WHATSAPP_NUMBER`), SendGrid/SMTP for mail

3. **Database**

   ```bash
   rails db:create db:migrate
   ```

   Seed if your project provides seeds:

   ```bash
   rails db:seed
   ```

4. **Run the app**

   ```bash
   rails server
   ```

   Visit `http://localhost:3000`.

   For background jobs in development, run Sidekiq in another terminal if needed:

   ```bash
   bundle exec sidekiq
   ```

## Tests

The project uses **RSpec**. See [`RSPEC_SETUP.md`](RSPEC_SETUP.md) if present for local notes.

```bash
bundle exec rspec
```

## Cart behaviour (overview)

- **Product listings / product page**: “Add to cart” adds one unit; after that, a pill-shaped quantity stepper (− / count / +) appears and updates the cart via JSON APIs.
- **Cart page**: The same stepper pattern adjusts quantity; updates apply via **Turbo Streams** so line totals, order summary, and the header cart count stay in sync without a full page reload.

## Configuration highlights

- [`config/database.yml`](config/database.yml) — database names and credentials
- [`config/routes.rb`](config/routes.rb) — cart, orders, API namespaces
- `.env.example` — template for secrets and third-party keys

## Deployment

Use your usual Rails deployment target (e.g. Heroku, Kamal, VPS). Ensure production has PostgreSQL, Redis, `SECRET_KEY_BASE`, Stripe keys, and any mail provider variables set. Precompile assets per your pipeline (`rails assets:precompile` where applicable).

---

For generic Rails documentation, see the [Rails Guides](https://guides.rubyonrails.org/).
