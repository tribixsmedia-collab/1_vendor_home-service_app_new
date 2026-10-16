#!/usr/bin/env bash
#
# Build the vendor app for the web and package it for the server.
#
#   ./build_web.sh                        # uses the sslip API host below
#   API_BASE_URL=https://api.example.com/api ./build_web.sh
#
# Produces build/web/ and homeservice-vendor.tar.gz next to it. Upload steps
# are printed at the end; see home_service_backend/deploy/UPDATING.md.
#
# Note on what the web build cannot do: push notifications are off, because
# Firebase has no Web app registered for this project. Jobs, bookings,
# earnings and every other API-backed screen work normally -- a vendor simply
# will not get a browser alert for a new job and must refresh. See
# PushService.isSupported.

set -euo pipefail

# The API address is COMPILED IN. A web build points at whatever host was given
# here, for ever -- there is no runtime setting to change afterwards.
API_BASE_URL="${API_BASE_URL:-https://13-200-180-192.sslip.io/api}"

cd "$(dirname "$0")"

case "$API_BASE_URL" in
    https://*) ;;
    *)
        echo "Refusing to build: API_BASE_URL is not https." >&2
        echo "  got: $API_BASE_URL" >&2
        echo "A page served over https cannot call a plain-http API -- browsers" >&2
        echo "block it as mixed content, and the app loads then does nothing." >&2
        exit 1
        ;;
esac

echo "==> Building against $API_BASE_URL"
flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"

echo "==> Packaging"
rm -f homeservice-vendor.tar.gz
# The leading "." includes dotfiles.
tar -czf homeservice-vendor.tar.gz -C build/web .

SIZE=$(du -h homeservice-vendor.tar.gz | cut -f1)
echo ""
echo "==> Built: homeservice-vendor.tar.gz ($SIZE)"
echo ""
echo "Upload and install it with:"
echo ""
echo "  scp -i C:/keys/homeservice-key.pem homeservice-vendor.tar.gz ubuntu@13.200.180.192:/tmp/"
echo ""
echo "  ssh -i C:/keys/homeservice-key.pem ubuntu@13.200.180.192 \\"
echo "    \"sudo rm -rf /srv/homeservice-vendor/* \\"
echo "     && sudo tar -xzf /tmp/homeservice-vendor.tar.gz -C /srv/homeservice-vendor \\"
echo "     && sudo chown -R www-data:www-data /srv/homeservice-vendor \\"
echo "     && rm /tmp/homeservice-vendor.tar.gz && echo DONE\""
echo ""
