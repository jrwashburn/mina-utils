We also run The Mina Pool - https://theminapool.com

# mina-utils
Mina protocol hosting utilities 

** WARNING ** 
This repo is used to update mina nodes, so scripts may have default values for keys, nodes, etc. 
Do not use without reviewing and updating for your own keys, fee strategy, addresses, etc.

* snark-stopper.sh checks mina status to determine when the next block producer opportunity is; turns off snark worker ~5 mins before the slot, resumes after 5 mins. Will set a random snark work fee between 1 and .001 (controlled with MAX_FEE / FEE_SCALE variables) 
	* Make sure to update the SW_ADDRESS to your snark worker address!

* status-watchdog.sh checks mina status every 5 minutes, if node is Offline, checks latest peers from test world source (should be updated when network peers location changes) and adds new peers if any. If node stays Offline > 20m, or Connecting > 10m, will restart daemon.
  * assumes running under systemd
