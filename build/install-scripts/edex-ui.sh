#!/usr/bin/env bash
set -e

echo "Downloading release for eDEX-UI (https://github.com/GitSquared/edex-ui) . . ."
EDEX_DOWNLOAD_URL=$(curl https://api.github.com/repos/GitSquared/edex-ui/releases/latest | jq -r '.assets[].browser_download_url' | grep "eDEX-UI.Linux.x86_64.AppImage")
echo "EDEX UI Download URL: $EDEX_DOWNLOAD_URL"

curl -L $EDEX_DOWNLOAD_URL --output eDEX-UI.Linux.x86_64.AppImage
chmod +x eDEX-UI.Linux.x86_64.AppImage

./eDEX-UI.Linux.x86_64.AppImage --appimage-extract
rm eDEX-UI.Linux.x86_64.AppImage

mv ./squashfs-root /usr/local/bin/edex-ui
chown -R 1000 /usr/local/bin/edex-ui

