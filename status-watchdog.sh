PEERSURL="https://raw.githubusercontent.com/MinaProtocol/coda-automation/bug-bounty-net/terraform/testnets/testworld/peers.txt"
STAT=""
CONNECTINGCOUNT=0
OFFLINECOUNT=0
TOTALCONNECTINGCOUNT=0
TOTALOFFLINECOUNT=0

function Update_Peers() {
  wget -O ~/new-peers.txt "${PEERSURL}"
  if ! diff -q ~/peers.txt ~/new-peers.txt; then
    echo "updating peers"
    cp ~/new-peers.txt ~/peers.txt
    cat ~/peers.txt | xargs -I % coda advanced add-peers %
  else
    echo "peers are the same - not adding to daemon"
  fi
  rm ~/new-peers.txt
}

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
    Update_Peers
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

  echo "Status:" $STAT, "Connecting Count, Total:" $CONNECTINGCOUNT $TOTALCONNECTINGCOUNT, "Offline Count, Total:" $OFFLINECOUNT $TOTALOFFLINECOUNT
  echo "sleeping for 5 mins"
  sleep 300s
done
