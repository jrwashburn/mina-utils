# Setting up a Snark Coordinator & Workers

A Snark Coordinator controls snark work distribution among many snark workers. The snark coordinator also sets the fee at which snark work is sold.

First, you need to run the coordinator and make it accessible to your other nodes by adding -bind-ip, -run-snark-coordinator, and -snark-work-fee to the EXTRA_FLAGS line in your .mina-env file. e.g. 

```EXTRA_FLAGS="-bind-ip [10.0.1.30] -run-snark-coordinator [PUBLIC KEY] -snark-worker-fee [FEE]"```


(Note: You can run the coordinator or the worker from the daemon - not both. If you specify -run-snark-worker [public key], that will override the -run-snark-coordinator flag.)

Second, you'll need to let your daemon node know what other nodes you trust to connect using the coda advanced client-trustlist command. For example:

```mina advanced client-trustlist add -ip-address 10.0.1.35/32``` 

(Note the IP address is in CIDR notation, /32 means just one IP. Useful chart: http://www.rjsmith.com/CIDR-Table.html)

You'll need to make sure your firewall / network allows traffic on port 8301, but you should limit that to your nodes. 

Now, with node 1 running coda daemon (with -run-snark-coordinator), on node 2+, run 
```mina internal snark-worker -daemon-address [COORDINATOR IP]:8301 -proof-level full -shutdown-on-disconnect false```

Note you don't need to run the mina daemon on the worker nodes, just ```coda internal snark-worker```.

//TODO: 
1) setup systemd templates - jkrauska knock-off (https://github.com/jkrauska/coda-systemd)
2) decide to run 1 thread per or just let the snark worker decide