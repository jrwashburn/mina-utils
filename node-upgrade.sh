BUILD="mina-testnet-postake-medium-curves=0.2.2-1-b14e324"

systemctl --user stop mina
sudo apt-get remove -y mina-testnet-postake-medium-curves
echo "deb [trusted=yes] http://packages.o1test.net release main" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt-get update
sudo apt-get install -y curl unzip $BUILD --allow-downgrades
systemctl --user daemon-reload
systemctl --user start mina
systemctl --user status mina
