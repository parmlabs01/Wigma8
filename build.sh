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

./_flutter_sdk/bin/flutter config --enable-web
./_flutter_sdk/bin/flutter create . --platforms=web
./_flutter_sdk/bin/flutter pub get

cp custom_index.html web/index.html
cp assets/images/icon_512.png web/icons/Icon-512.png
cp assets/images/icon_192.png web/icons/Icon-192.png
cp assets/images/icon_512_maskable.png web/icons/Icon-maskable-512.png
cp assets/images/icon_192_maskable.png web/icons/Icon-maskable-192.png
cp assets/images/favicon.png web/favicon.png

./_flutter_sdk/bin/flutter build web --release
