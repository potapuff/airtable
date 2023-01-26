bundle install
thin -O -e production -s 2 -S tmp/thin.mooc.sock -d restart