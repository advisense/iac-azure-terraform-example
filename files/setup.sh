#!/bin/sh
# Deploys a simple Apache webpage.

# cd /tmp
apt-get -y update > /dev/null 2>&1
apt install -y apache2 > /dev/null 2>&1

cat << EOM > /var/www/html/index.html
<html>
  <head><title>Test is up and running!</title></head>
  <body style="background-image: linear-gradient(red,orange,yellow,green,blue,indigo,violet);">
  <centerHELLO WORLD!</center>
  <marquee><h1>Meow World</h1></marquee>
  </body>
</html>
EOM

echo "The demosite is now ready."