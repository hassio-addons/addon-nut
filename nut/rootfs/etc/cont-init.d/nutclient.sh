#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Network UPS Tools
# Configures Network UPS Tools for Client Mode only
# ==============================================================================
readonly UPSMON_CONF=/etc/nut/upsmon.conf
declare deadtime=15
declare -a CONF_ENTRIES=("name" "host" "password" "user")

if bashio::config.equals 'mode' 'netclient'; then
    for entry in "${CONF_ENTRIES[@]}"; do
        if ! bashio::config.exists "remote_ups_${entry}"; then
        bashio::exit.nok \
            "Netclient mode specified but no ${entry} is configured"
        fi
    done

    rname=$(bashio::config "remote_ups_name")
    rhost=$(bashio::config "remote_ups_host")
    ruser=$(bashio::config "remote_ups_user")
    rpwd=$(bashio::config "remote_ups_password")
    echo "MONITOR ${rname}@${rhost} 1 ${ruser} ${rpwd} slave" >> "${UPSMON_CONF}"
fi

if bashio::config.has_value "upsmon_deadtime"; then
    deadtime=$(bashio::config "upsmon_deadtime")
fi

echo "DEADTIME ${deadtime}" >> "${UPSMON_CONF}"
