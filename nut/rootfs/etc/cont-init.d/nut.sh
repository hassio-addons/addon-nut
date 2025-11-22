#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Network UPS Tools
# Configures Network UPS Tools
# ==============================================================================
readonly NUT_CONF=/etc/nut/nut.conf
readonly USERS_CONF=/etc/nut/upsd.users
readonly UPSD_CONF=/etc/nut/upsd.conf
readonly UPS_CONF=/etc/nut/ups.conf
readonly UPSMON_CONF=/etc/nut/upsmon.conf
declare nutmode
declare password
declare shutdowncmd
declare upsmonpwd
declare username

chown root:root /var/run/nut
chmod 0770 /var/run/nut

chown -R root:root /etc/nut
find /etc/nut -not -perm 0660 -type f -exec chmod 0660 {} \;
find /etc/nut -not -perm 0660 -type d -exec chmod 0660 {} \;

nutmode=$(bashio::config 'mode')
bashio::log.info "Setting mode to ${nutmode}..."
sed -i "s#%%nutmode%%#${nutmode}#g" "${NUT_CONF}"

if bashio::config.true 'list_usb_devices'; then
    bashio::log.info 'Connected USB devices:'
    lsusb
fi

if bashio::config.equals 'mode' 'netserver'; then
    bashio::log.info "Generating ${USERS_CONF}..."

    # Create Monitor User
    upsmonpwd=$(shuf -ze -n20  {A..Z} {a..z} {0..9}|tr -d '\0')
    {
        echo
        echo "[upsmonmaster]"
        echo "  password = ${upsmonpwd}"
        echo "  upsmon master"
    } >> "${USERS_CONF}"

    for user in $(bashio::config "users|keys"); do
        bashio::config.require.username "users[${user}].username"
        username=$(bashio::config "users[${user}].username")

        bashio::log.info "Configuring user: ${username}"
        if ! bashio::config.true 'i_like_to_be_pwned'; then
            bashio::config.require.safe_password "users[${user}].password"
        else
            bashio::config.require.password "users[${user}].password"
        fi
        password=$(bashio::config "users[${user}].password")

        {
            echo
            echo "[${username}]"
            echo "  password = ${password}"
        } >> "${USERS_CONF}"

        for instcmd in $(bashio::config "users[${user}].instcmds"); do
            echo "  instcmds = ${instcmd}" >> "${USERS_CONF}"
        done

        for action in $(bashio::config "users[${user}].actions"); do
            echo "  actions = ${action}" >> "${USERS_CONF}"
        done

        if bashio::config.has_value "users[${user}].upsmon"; then
            upsmon=$(bashio::config "users[${user}].upsmon")
            echo "  upsmon ${upsmon}" >> "${USERS_CONF}"
        fi
    done

    if bashio::config.has_value 'upsd_maxage'; then
        maxage=$(bashio::config 'upsd_maxage')
        echo "MAXAGE ${maxage}" >> "${UPSD_CONF}"
    fi

    for device in $(bashio::config "devices|keys"); do
        upsname=$(bashio::config "devices[${device}].name")
        upsdriver=$(bashio::config "devices[${device}].driver")
        upsport=$(bashio::config "devices[${device}].port")
        if bashio::config.has_value "devices[${device}].powervalue"; then
            upspowervalue=$(bashio::config "devices[${device}].powervalue")
        else
            upspowervalue='1'
        fi

        bashio::log.info "Configuring Device named ${upsname}..."
        {
            echo
            echo "[${upsname}]"
            echo "  driver = ${upsdriver}"
            echo "  port = ${upsport}"
        } >> "${UPS_CONF}"

        OIFS=$IFS
        IFS=$'\n'
        for configitem in $(bashio::config "devices[${device}].config"); do
            echo "  ${configitem}" >> "${UPS_CONF}"
        done
        IFS="$OIFS"

        echo "MONITOR ${upsname}@localhost ${upspowervalue} upsmonmaster ${upsmonpwd} master" \
            >> "${UPSMON_CONF}"
    done

    bashio::log.info 'Starting the UPS drivers...'
    # Run upsdrvctl
    if bashio::debug; then
        upsdrvctl -u root -D start
    else
        upsdrvctl -u root start
    fi
fi

shutdowncmd='/run/s6/basedir/bin/halt'
if bashio::config.true 'shutdown_host'; then
    bashio::log.warning 'UPS Shutdown will shutdown the host'
    shutdowncmd='/usr/bin/shutdownhost'
fi

echo "SHUTDOWNCMD ${shutdowncmd}" >> "${UPSMON_CONF}"
