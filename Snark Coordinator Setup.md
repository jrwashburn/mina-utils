Setting up a Snark Coordinator & Workers

A Snark Coordinator controls snark work distribution among many snark workers. The snark coordinator also sets the fee at which snark work is sold.

First, you need to run the coordinator and make it accessible to your other nodes by adding -bind-ip, -run-snark-coordinator, and -snark-work-fee to the EXTRA_FLAGS line in your .mina-env file. e.g. 
```EXTRA_FLAGS="-bind-ip 10.16.53.50 -run-snark-coordinator [ADDRESS] -snark-worker-fee [FEE]"```

Second, you'll need to let your daemon node know what other nodes you trust to connect using the coda advanced client-trustlist command. For example:
```coda advanced client-trustlist add -ip-address 167.172.129.33/32``` (Note the IP address is in CIDR notation, /32 means just one IP. If you need a subnet, see: http://www.rjsmith.com/CIDR-Table.html)

You'll need to make sure your firewall / network allows traffic on port 8301, but you should limit that to your nodes. 

That's it. Now, assuming node 1 running coda daemon (with -run-snark-coordinator), on node 2 through n, just run 
```coda internal snark-worker -daemon-address [COORDINATOR IP]:8301 -proof-level full -shutdown-on-disconnect false```

Note you don't need to run the daemon, etc. on the snark worker nodes, just ```coda internal snark-worker```.

//TODO: 
1) setup systemd templates - jkrauska knock-off
2) decide to run 1 thread per or just let the snark worker decide