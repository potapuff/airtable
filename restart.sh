bundle install
thin -O -e production -s 1 -S tmp/thin.mooc.sock -d restart