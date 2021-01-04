while :
do
 wget -O ~/new-peers.txt https://raw.githubusercontent.com/MinaProtocol/coda-automation/bug-bounty-net/terraform/testnets/testworld/peers.txt
 if ! diff -q peers.txt new-peers.txt ; then 
	echo "updating peers"
	cp new-peers.txt peers.txt
	cat peers.txt | xargs -I % coda advanced add-peers %
 else
	 echo "peers are the asame - not adding to daemon"
 fi
 date; echo "sleepting for 30 mins"
 sleep 1800s
done

