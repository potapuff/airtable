# mooc-for-ua

Backend for site Coursera to Ukrain course colaboration.

Used:
* ruby 3.1+ 
  * sinatra
* Google Sheets - haha!

# Install & run 

1. Substitute config/* files with real values
2. bundle install
3. thin -O -e production  -S tmp/thin.mooc.sock -d start

# Docker

1. Create folder "secrets" and  out key.json (Goolge credentials) and production.yaml here.
2. Start project with docker-start.bat or docker compose