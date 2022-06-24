bundle install
thin -O -e production -S tmp/thin.mooc.sock -d restart