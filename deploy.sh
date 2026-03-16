# set -e

# # --- 1. Navigate to app directory ---
# APP_DIR="/home/ubuntu/homedecor"
# cd $APP_DIR

# echo "✅ Switched to app directory: $APP_DIR"

# # --- 2. Pull latest code from Git ---
# echo "🔄 Pulling latest code..."
# git fetch --all
# git reset --hard origin/main
# echo "✅ Code updated"

# # --- 3. Set environment variables ---
# export RAILS_ENV=production
# export SECRET_KEY_BASE="a637e094e7b09eae1caf60f4a1586cb040a1ed63d4404db3897adbbae6bb497e02a7388c680f5ba6260a380aa14278a9936311fac337761eb1a6a63020b38508"

# # --- 4. Install gems ---
# echo "💎 Installing gems..."
# bundle install --jobs=4 --retry=3
# echo "✅ Gems installed"

# # --- 5. Migrate database ---
# echo "🗄 Migrating database..."
# rails db:migrate
# echo "✅ Database migrated"

# # --- 6. Precompile assets ---
# echo "🎨 Precompiling assets..."
# rails assets:precompile
# echo "✅ Assets precompiled"

# # --- 7. Restart Puma (or your app server) ---
# echo "🔄 Restarting Puma..."
# # If using systemd for Puma:
# sudo systemctl restart puma
# # If using bundle exec directly:
# # pkill -f puma || true
# # bundle exec puma -C config/puma.rb -d

# echo "🚀 Deployment finished successfully!"


# !/bin/bash
#!/bin/bash
set -e

cd /home/ubuntu/homedecor

echo "🔄 Pulling latest code..."
git pull origin main

echo "🐳 Rebuilding Docker..."
docker compose down

docker compose build

echo "🗄 Starting database and redis..."
docker compose up -d postgres redis

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Run migrations separately
echo "🗄 Running database setup..."
docker compose run --rm web bundle exec rails db:migrate

echo "🚀 Starting web service..."
docker compose up -d web

echo "📋 Checking container status..."
docker compose ps

echo "📋 Checking logs..."
docker compose logs --tail=50 web

echo "✅ Deployment completed!"


