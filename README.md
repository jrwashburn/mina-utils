# mina-utils
Mina protocol hosting utilities

* status-watchdog.sh checks mina status every 5 minutes, if node is Offline, checks latest peers from test world source (should be updated when network peers location changes) and adds new peers if any. If node stays Offline > 20m, or Connecting > 10m, will restart daemon.
  * assumes running under systemd
