while :
do
  MINA_PROCESSES_RUNNING="$(ps -A | grep coda | wc -l)"
  if (( $CODA_PROCESSES_RUNNING > 2 )) then
    echo "More than 2 coda running, we have at least 1 snark workers"
  else
    echo "starting 4 snark workers"
    mina internal snark-worker -daemon-address $MINA_COORDINATOR -proof-level full -shutdown-on-disconnect false >>~/logs/snarkworker1.log &
    mina internal snark-worker -daemon-address $MINA_COORDINATOR -proof-level full -shutdown-on-disconnect false >>~/logs/snarkworker2.log &
    mina internal snark-worker -daemon-address $MINA_COORDINATOR -proof-level full -shutdown-on-disconnect false >>~/logs/snarkworker3.log &
    mina internal snark-worker -daemon-address $MINA_COORDINATOR -proof-level full -shutdown-on-disconnect false >>~/logs/snarkworker4.log &
    disown $( jobs -p )
  fi
  sleep 300s  
  test $? -gt 128 && break;
done