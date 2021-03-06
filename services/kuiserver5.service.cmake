#
# Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# Starts kuiserver5.
#

[Unit]
Description=kuiserver5

[Service]
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=%t/dbus/user_bus_socket
EnvironmentFile=-/var/lib/environment/plasma-phone/*.conf
ExecStart=@CMAKE_INSTALL_FULL_BINDIR@/kuiserver5
BusName=org.kde.kuiserver
