#!/bin/bash
cat > /usr/share/nginx/html/env-config.js << 'EOF'
window.ENV = {
  API_BASE_URL: "${API_BASE_URL:-http://localhost:3030}"
};
EOF