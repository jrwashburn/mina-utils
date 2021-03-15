We also run The Mina Pool - https://theminapool.com

** THIS REPO IS DEPRECATED **  
** SEE https://github.com/jrwashburn/mina-node-install **

# mina-utils
Mina protocol hosting utilities 

## mina-archive.service

systemd config file to run mina archive service. 
copy this file to /usr/lib/systemd/user/mina-archive.service
uses same environment file as coda daemon (~/.mina-env)
See also: https://minaprotocol.com/docs/archive-node 
	
	* Assumes POSTGRES_URI variable will be found in .mina-env - that should be your full URI to login to the postgres database. 
	Note this is unsafe w/r/t that database username and password laying around in config, but even worse, being available in a process list. 
	That's how it works for right now.
		
		postgres://USERNAME:PASSWORD@POSTGRESHOST:POSTGRESPORT/archive"

	* Also assumes you have setup the archive service
		
		sudo apt-get install mina-archive
		createdb -h postgres://USERNAME:PASSWORD@POSTGRESHOST -p POSTGRESPORT -e archive
		psql -h postgres://USERNAME:PASSWORD@POSTGRESHOST -p POSTGRESPORT -d archive -f <(curl -Ls https://raw.githubusercontent.com/MinaProtocol/mina/master/src/app/archive/create_schema.sql)
		coda-archive run --postgres-uri postgres://USERNAME:PASSWORD@POSTGRESHOST:POSTGRESPORT/archive --server-port 3086 &
	
	* You may also need to make network changes to allow your node to connect to the archive service on port 3086
	
		sudo ufw allow from NODEIP to any port 3086


## snark-stopper.sh

checks mina status to determine when the next block producer opportunity is; turns off snark worker ~5 mins before the slot, resumes after 5 mins. Will set a random snark work fee between 1 and .001 (controlled with MAX_FEE / FEE_SCALE variables) 

	* Make sure to update the SW_ADDRESS to your snark worker address!


## status-watchdog.sh

checks mina status every 5 minutes, if node is Offline, ~~checks latest peers from test world source (should be updated when network peers location changes) and adds new peers if any~~. If node stays Offline > 20m, or Connecting > 10m, will restart daemon.

	* assumes running under systemd


