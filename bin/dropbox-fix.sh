#!/bin/bash
# dropbox-fix.sh - Fix Dropbox file provider registration and cache on macOS
# Tested macOS Sequoia 15.x (Apple Silicon / Intel)

set -e

echo "🔧 Fixing Dropbox File Provider registration..."

# Quit Dropbox processes
echo "→ Quitting Dropbox..."
pkill -f "Dropbox" || true

# Unregister and deregister stale provider
echo "→ Removing old File Provider registration..."
pluginkit -r com.getdropbox.dropbox.fileprovider 2>/dev/null || true
pluginkit -d com.getdropbox.dropbox.fileprovider 2>/dev/null || true

# Re-register Dropbox File Provider
if [ -d "/Applications/Dropbox.app/Contents/PlugIns/FileProviderExtension.appex" ]; then
    echo "→ Re-registering Dropbox File Provider..."
    pluginkit -a "/Applications/Dropbox.app/Contents/PlugIns/FileProviderExtension.appex"
else
    echo "⚠️ Dropbox FileProviderExtension not found. Ensure Dropbox is installed in /Applications."
    exit 1
fi

# Clear Dropbox cache and config (non-destructive to synced data)
echo "→ Clearing Dropbox caches..."
rm -rf ~/Library/Application\ Support/Dropbox 2>/dev/null || true
rm -rf ~/.dropbox 2>/dev/null || true
rm -rf ~/Library/CloudStorage/Dropbox/.dropbox.cache 2>/dev/null || true

# Reset File Provider state (optional)
echo "→ Resetting FileProvider state..."
sudo rm -rf /Library/FileProvider 2>/dev/null || true
sudo rm -rf ~/Library/FileProvider 2>/dev/null || true

echo "→ Rebooting system to complete repair..."
sudo shutdown -r now

