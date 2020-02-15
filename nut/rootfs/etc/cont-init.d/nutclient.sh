#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Network UPS Tools
# Configures Network UPS Tools for Client Mode only
# ==============================================================================
declare -a CONF_ENTRIES=("name" "host" "password" "user")

if bashio::config.equals 'mode' 'netclient' ;then

    for entry in "${CONF_ENTRIES[@]}"; do
        if ! bashio::config.exists "remote_ups_${entry}";then
        bashio::log.fatal \
		"Netclient mode specified but no ${entry} is configured"
		bashio::exit.nok
	    fi
    done

    rname=$(bashio::config "remote_ups_name")
    rhost=$(bashio::config "remote_ups_host")
    ruser=$(bashio::config "remote_ups_user")
    rpwd=$(bashio::config "remote_ups_password")

    echo "MONITOR ${rname}@${rhost} 1 ${ruser} ${rpwd} slave" \
        >> /etc/nut/upsmon.conf
fi
