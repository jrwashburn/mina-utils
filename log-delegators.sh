#log delegators
POOLADDRESS='B62YOURPOOL';
TODAY=`date +%Y%m%d-%H%M%S`;
STAKINGFILE=~/logs/staking-ledger-"$today.json";
DELEGATORSFILE=~/logs/delegators-"$today.json";

coda ledger export staking-epoch-ledger > "$STAKINGFILE";

jq -c --arg POOLADDRESS "$POOLADDRESS" '.[] | select(.delegate==$POOLADDRESS) | {delegator: .pk, balance: .balance}' $STAKINGFILE >$DELEGATORSFILE;

jq -s '{total: map(.balance|tonumber) | add}' $DELEGATORSFILE >> $DELEGATORSFILE;
