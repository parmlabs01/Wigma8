#!/bin/bash
set -e

git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter_sdk

cat > .env << EOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
OPENAI_API_KEY=$OPENAI_API_KEY
GEMINI_API_KEY=$GEMINI_API_KEY
STABILITY_API_KEY=$STABILITY_API_KEY
FLUX_API_KEY=$FLUX_API_KEY
EOF

echo "--- DEBUG: .env contents ---"
cat .env
echo "-----------------------------"

./_flutter_sdk/bin/flutter config --enable-web
./_flutter_sdk/bin/flutter create . --platforms=web
./_flutter_sdk/bin/flutter pub get
./_flutter_sdk/bin/flutter build web --release
