systemctl --user stop mina
echo Y | sudo apt-get remove mina-testnet-postake-medium-curves
echo "deb [trusted=yes] http://packages.o1test.net release main" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt-get update
sudo apt-get install -y curl mina-testnet-postake-medium-curves=0.2.2+-hotfix-super-catchup-restart-libp2p-upload-blocks-9614ad9 --allow-downgrades
systemctl --user daemon-reload
systemctl --user start mina
systemctl --user status mina