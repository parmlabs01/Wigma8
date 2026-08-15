#!/bin/bash
set -e

# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"
flutter config --enable-web
flutter doctor

# Write environment variables into .env for flutter_dotenv
cat > .env << EOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
OPENAI_API_KEY=$OPENAI_API_KEY
GEMINI_API_KEY=$GEMINI_API_KEY
STABILITY_API_KEY=$STABILITY_API_KEY
FLUX_API_KEY=$FLUX_API_KEY
EOF

flutter create . --platforms=web
flutter pub get
flutter build web --release
