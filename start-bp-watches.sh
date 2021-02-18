~/mina-utils/snarkstopper.sh >>~/logs/snarkstopper.log &
~/mina-utils/status-watchdog.sh >>~/logs/status-watchdog.log &
jobs
disown $(jobs -p)

