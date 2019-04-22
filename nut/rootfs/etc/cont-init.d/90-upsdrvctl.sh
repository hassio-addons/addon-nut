#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Network UPS Tools
# Starts UPS drivers
# ==============================================================================
bashio::log.info "Starting the UPS drivers"

# Run upsdrvctl
if bashio::debug; then
    exec upsdrvctl -D start
else
    exec upsdrvctl start
fi
