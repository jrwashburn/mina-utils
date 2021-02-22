STAT=""
ARCHIVESTAT=0
CONNECTINGCOUNT=0
OFFLINECOUNT=0
TOTALCONNECTINGCOUNT=0
TOTALOFFLINECOUNT=0
ARCHIVEDOWNCOUNT=0

while :; do
  date
  STAT="$(coda client status -json | jq .sync_status)"

  if [[ "$STAT" == "\"Synced\"" ]]; then
    echo "In Sync-all good"
    OFFLINECOUNT=0
    CONNECTINGCOUNT=0
  fi

  if [[ "$STAT" == "\"Connecting\"" ]]; then
    echo "Connecting"
    ((CONNECTINGCOUNT++))
    ((TOTALCONNECTINGCOUNT++))
  fi

  if [[ "$STAT" == "\"Offline\"" ]]; then
    echo "Offline"
    ((OFFLINECOUNT++))
    ((TOTALOFFLINECOUNT++))
    #Update_Peers
  fi

  if [[ "$CONNECTINGCOUNT" > 1 ]]; then
    echo "Connecting - recycle"
    systemctl --user restart mina
    CONNECTINGCOUNT=0
  fi

  if [[ "$OFFLINECOUNT" > 3 ]]; then
    echo "Offline - recycle - should never happen"
    systemctl --user restart mina
    OFFLINECOUNT=0
  fi

  ARCHIVERUNNING=`ps -A | grep coda-archive | wc -l`

  if [[ "$ARCHIVERUNNING" > 0 ]]; then
    echo "Archive is Running - ok"
    ARCHIVERRUNNING=0
  else
    ((ARCHIVEDOWNCOUNT++))
    echo "ARCHIVE IS NOT RUNNING - ERROR"
  fi 

  echo "Status:" $STAT, "Connecting Count, Total:" $CONNECTINGCOUNT $TOTALCONNECTINGCOUNT, "Offline Count, Total:" $OFFLINECOUNT $TOTALOFFLINECOUNT, "Archive Down Count:" $ARCHIVEDOWNCOUNT
  echo "sleeping for 5 mins"
  sleep 300s
  test $? -gt 128 && break;
done
