We also run The Mina Pool - https://theminapool.com

# mina-utils
Mina protocol hosting utilities 

** WARNING ** 
This repo is used to update mina nodes, so scripts may have default values for keys, nodes, etc. 
Do not use without reviewing and updating for your own keys, fee strategy, addresses, etc.

I know it could be easier and provide more automation and parameterization.... just not yet. 


**mina-archive.service**

systemd config file to run mina archive service. 
copy this file to /usr/lib/systemd/user/mina-archive.service
uses same environment file as coda daemon (~/.mina-env)
	
	* Assumes POSTGRES_URI variable will be found in .mina-env - that should be your full URI to login to the postgres database. Note this is unsafe w/r/t that database username and password laying around in config, but even worse, being available in a process list. That's how it works for right now.
		
		postgres://USERNAME:PASSWORD@POSTGRESHOST:POSTGRESPORT/archive"

	* Also assumes you have setup the archive service
		
		sudo apt-get install mina-archive
		createdb -h postgres://USERNAME:PASSWORD@POSTGRESHOST -p POSTGRESPORT -e archive
		psql -h postgres://USERNAME:PASSWORD@POSTGRESHOST -p POSTGRESPORT -d archive -f <(curl -Ls https://raw.githubusercontent.com/MinaProtocol/mina/master/src/app/archive/create_schema.sql)
		coda-archive run --postgres-uri postgres://USERNAME:PASSWORD@POSTGRESHOST:POSTGRESPORT/archive --server-port 3086 &
	
	* You may also need to make network changes to allow your node to connect to the archive service on port 3086
	
		sudo ufw allow from NODEIP to any port 3086


**snark-stopper.sh**

checks mina status to determine when the next block producer opportunity is; turns off snark worker ~5 mins before the slot, resumes after 5 mins. Will set a random snark work fee between 1 and .001 (controlled with MAX_FEE / FEE_SCALE variables) 

	* Make sure to update the SW_ADDRESS to your snark worker address!


**status-watchdog.sh** 

checks mina status every 5 minutes, if node is Offline, checks latest peers from test world source (should be updated when network peers location changes) and adds new peers if any. If node stays Offline > 20m, or Connecting > 10m, will restart daemon.

	* assumes running under systemd


