#!/bin/bash

echo "Stopping any existing server on port 8080..."
lsof -ti tcp:8080 | xargs kill -9 2>/dev/null || true
sleep 0.5

echo "Starting SVCTE Bus App..."
echo ""

# Get the directory this script lives in
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
URL="http://localhost:8080/svcte-bus-app-v4.html"

# Function to open browser cross-platform
open_browser() {
  if command -v open &>/dev/null; then
    open "$URL"          # macOS
  elif command -v xdg-open &>/dev/null; then
    xdg-open "$URL"      # Linux
  else
    echo "Open this in your browser: $URL"
  fi
}

cd "$DIR"

# Try Python 3
if command -v python3 &>/dev/null; then
  echo "Found Python 3. Starting server at $URL"
  sleep 1 && open_browser &
  python3 -m http.server 8080
  exit 0
fi

# Try Python 2
if command -v python &>/dev/null; then
  PY_VER=$(python -c 'import sys; print(sys.version_info[0])')
  if [ "$PY_VER" = "3" ]; then
    echo "Found Python 3. Starting server at $URL"
    sleep 1 && open_browser &
    python -m http.server 8080
    exit 0
  else
    echo "Found Python 2. Starting server at $URL"
    sleep 1 && open_browser &
    python -m SimpleHTTPServer 8080
    exit 0
  fi
fi

# Try Node npx
if command -v npx &>/dev/null; then
  echo "Found Node.js. Starting server at $URL"
  sleep 1 && open_browser &
  npx serve -p 8080 -s .
  exit 0
fi

echo "ERROR: Could not find Python or Node.js."
echo "Install Python from https://python.org, then run:"
echo "  python3 -m http.server 8080"
echo "Then open: $URL"
exit 1
