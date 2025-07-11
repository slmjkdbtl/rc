# add user
adduser tga

# add sudo priviliedge to user
usermod -aG sudo tga

# copy ssh key to user
rsync --archive --chown=tga:tga ~/.ssh /home/tga

# change to user
su - tga

# install packages
sudo apt update
sudo apt upgrade
sudo apt install -y zsh vim make git sqlite3 zip

# clone this repo
git clone https://github.com/slmjkdbtl/rc .rc

# init config
cd .rc && make

# change default shell
chsh -s "$(which zsh)"
zsh
zplug install

# install bun
curl -fsSL https://bun.sh/install | SHELL="" bash
echo "export BUN_INSTALL="$HOME/.bun"" >> ~/.profile
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.profile

# server unit config
sudo tee /etc/systemd/system/space55.xyz.service > /dev/null << EOF
[Unit]
Description=space55.xyz
After=network.target

[Service]
User=tga
Environment="PORT=4000"
WorkingDirectory=/home/tga/space55.xyz
ExecStart=/bin/sh -l start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# reload unit file configs
sudo systemctl daemon-reload

# start server
sudo systemctl enable --now space55.xyz

# install caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy

# caddy config
sudo tee /etc/caddy/Caddyfile > /dev/null << EOF
space55.xyz {
    encode gzip
    reverse_proxy localhost:4000
}
EOF

# start caddy
sudo systemctl enable --now caddy

# reload caddy config
sudo systemctl reload caddy

# setup aria2c
sudo apt install aria2c
mkdir ~/downloads
mkdir -p ~/.local/share/aria2
touch ~/.local/share/aria2/daemon.session

sudo tee /etc/systemd/system/aria2.service > /dev/null << EOF
[Unit]
Description=aria2 daemon
After=network.target

[Service]
User=tga
ExecStart=/usr/bin/aria2c --conf-path=/home/tga/.config/aria2/daemon.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now aria2

# install shadowsocks
sudo apt install shadowsocks-libev shadowsocks-v2ray-plugin

# shadowsocks config
sudo tee /etc/shadowsocks-libev/config.json > /dev/null << EOF
{
    "server": "0.0.0.0",
    "server_port": 65521,
    "mode":"tcp_and_udp",
    "password": "woyaoshangwang",
    "method": "chacha20-ietf-poly1305",
    "plugin": "ss-v2ray-plugin",
    "plugin_opts": "server"
}
EOF
