#!/bin/bash -e

# INSTALL APPLICATION
sudo mkdir /app
sudo wget -O /app/gopher_search https://github.com/mekhatib/DBtest/blob/39b9cb72a86631719e77e6b9897ab5f25063e7d1/gopher_search
sudo chmod +x /app/gopher_search

connection="postgres://$2:$3@$1:5432/gopher_search_production?sslmode=disable"

# Setup SystemCTL
sudo tee /etc/systemd/system/gopher_search.service > /dev/null <<EOF
  [Unit]
  Description = "GopherSearch"
  
  [Service]
  Environment=DATABASE_URL=$connection
  Environment=GO_ENV=production
  KillSignal=INT
  ExecStart=/app/gopher_search
  Restart=always
  ExecStopPost=/bin/sleep 5
EOF

sudo systemctl daemon-reload
sudo systemctl enable gopher_search.service
sudo systemctl start gopher_search.service
