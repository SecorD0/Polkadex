#!/bin/bash
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
if [ ! $polkadex_moniker ]; then
	echo -n -e '\e[40m\e[92mEnter node moniker:\e[0m '
	read -r polkadex_moniker
	. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) "polkadex_moniker" $polkadex_moniker
fi
echo -e "Your node name: \e[40m\e[92m$polkadex_moniker\e[0m\n"
sudo apt update
sudo apt upgrade -y
sudo apt install jq unzip git build-essential pkg-config libssl-dev -y
echo -e '\e[40m\e[92mNode installation...\e[0m'
mkdir $HOME/polkadex
wget -qO $HOME/polkadex/PolkadexNodeUbuntu.zip https://github.com/Polkadex-Substrate/Polkadex/releases/download/v0.4.1-rc5/PolkadexNodeUbuntu.zip
unzip $HOME/polkadex/PolkadexNodeUbuntu.zip -d $HOME/polkadex/
rm -rf $HOME/polkadex/PolkadexNodeUbuntu.zip
chmod +x $HOME/polkadex/polkadex-node
cd
sudo tee <<EOF >/dev/null /etc/systemd/system/polkadexd.service
[Unit]
Description=Testnet
After=network-online.target
Wants=network-online.target
[Service]
User=$USER
ExecStart=$HOME/polkadex/polkadex-node --chain $HOME/polkadex/customSpecRaw.json --rpc-cors all --bootnodes /ip4/13.235.190.203/tcp/30333/p2p/12D3KooWC7VKBTWDXXic5yRevk8WS8DrDHevvHYyXaUCswM18wKd --name "$polkadex_moniker" --validator --telemetry-url 'wss://telemetry.polkadot.io/submit/ 0'
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable polkadexd
sudo systemctl daemon-reload
sudo systemctl restart polkadexd
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) "polkadex_log" "sudo journalctl -f -n 100 -u polkadexd" true
echo -e '\e[40m\e[92mDone!\e[0m'
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e '\nThe node was \e[40m\e[92mstarted\e[0m!\n'
echo -e 'Remember to save files in this directory:'
echo -e "\033[0;31m...\e[0m\n\n"
echo -e '\tv \e[40m\e[92mUseful commands\e[0m v\n'
echo -e 'To view the node status: \e[40m\e[92msystemctl status polkadexd\e[0m'
echo -e 'To view the node log: \e[40m\e[92mpolkadex_log\e[0m'
echo -e 'To restart the node: \e[40m\e[92msystemctl restart polkadexd\e[0m\n'