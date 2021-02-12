#Credit to _thanos - https://forums.minaprotocol.com/t/guide-script-automagically-stops-snark-work-prior-of-getting-a-block-proposal/299
#!/bin/bash

# Set readonly variables
readonly SECONDS_PER_MINUTE=60
readonly SECONDS_PER_HOUR=3600
# max fee established the upper boundary of fee, which will be divided by fee scale
#readonly MAX_FEE=1000
#readonly FEE_SCALE=1000
readonly SW_ADDRESS=B62qkBqSkXgkirtU3n8HJ9YgwHh3vUD6kGJ5ZRkQYGNPeL5xYL2tL1L

while true
do 
# Get next proposal time and remove "
NEXTPROP="$(coda client status -json | jq .next_block_production[1])"
NEXTPROP="${NEXTPROP:1}"
NEXTPROP="${NEXTPROP:0:-1}"
echo "Next prop is at  $NEXTPROP"

# Get current time and calculate time left before next proposal
NOW="$(date +%s%N | cut -b1-13)"
echo "Where are now at $NOW"

TIMEBEFORENEXT="$(($NEXTPROP-$NOW))"
echo "Time before next block $TIMEBEFORENEXT"

TIMEBEFORENEXTSEC="${TIMEBEFORENEXT:0:-3}"
echo "in seconds $TIMEBEFORENEXTSEC "

TIMEBEFORENEXTMIN="$((${TIMEBEFORENEXTSEC} / ${SECONDS_PER_MINUTE}))"
echo "in minutes $TIMEBEFORENEXTMIN"

# Check if the next proposal is within 3 minutes
if [ $TIMEBEFORENEXTMIN -lt 3 ]
then
    echo "Stop snarking"
    coda client set-snark-worker
    echo "Sleep 600"
    sleep 600
    echo "Start snarking"
    coda client set-snark-worker -address ${SW_ADDRESS}
else
    # Do nothing
    #fee=$(( $RANDOM % ${MAX_FEE} ))
    #fee=$( bc <<< "scale=3;$fee/ ${FEE_SCALE}" )
    fee=0.25
    echo "setting snark work fee to " $fee
    coda client set-snark-work-fee $fee
    echo "Block too far away"
fi

SLEEP="$((${TIMEBEFORENEXTSEC} / 2))"
echo "Sleep for $SLEEP"
sleep $SLEEP
test $? -gt 128 && break;
done
