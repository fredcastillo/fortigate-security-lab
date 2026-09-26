#!/bin/bash
set -e
WEB_DIR="$HOME/lab-images/web"
mkdir -p "$WEB_DIR"
cat > "$WEB_DIR/Dockerfile" <<'EOF'
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y apache2 php libapache2-mod-php php-mysqli openssl iproute2 net-tools iputils-ping && apt clean
RUN mkdir -p /etc/ssl/lab &&     openssl req -x509 -nodes -days 365 -newkey rsa:2048     -keyout /etc/ssl/lab/web.key -out /etc/ssl/lab/web.crt     -subj "/C=DO/O=Lab/CN=web.lab.local"
RUN a2enmod ssl &&     sed -i 's#/etc/ssl/certs/ssl-cert-snakeoil.pem#/etc/ssl/lab/web.crt#; s#/etc/ssl/private/ssl-cert-snakeoil.key#/etc/ssl/lab/web.key#' /etc/apache2/sites-available/default-ssl.conf &&     a2ensite default-ssl
RUN cat > /var/www/html/search.php <<'PHP'
<?php
$db_host = getenv('DB_IP') ?: '10.21.75.146';
$c = new mysqli($db_host,"webuser","Lab#2175","labdb");
$id = $_GET['id'] ?? 1;
$r = $c->query("SELECT id,name FROM users WHERE id=$id");
while($row=$r->fetch_assoc()) echo $row['id']." - ".$row['name']."<br>";
PHP
RUN cp /bin/ls /var/www/html/test.exe
ENV IP_ADDR=10.21.75.130 PREFIX=28 GATEWAY=10.21.75.129 DB_IP=10.21.75.146
COPY start-network.sh /start-network.sh
RUN chmod +x /start-network.sh
CMD ["/start-network.sh"]
EOF
cat > "$WEB_DIR/start-network.sh" <<'EOF'
#!/bin/bash
exec > /var/log/start-network.log 2>&1
set -e
IP_ADDR="${IP_ADDR:-10.21.75.130}"
PREFIX="${PREFIX:-28}"
GATEWAY="${GATEWAY:-10.21.75.129}"
for i in $(seq 1 15); do ip link show eth0 >/dev/null 2>&1 && break; sleep 1; done
ip addr flush dev eth0
ip addr add ${IP_ADDR}/${PREFIX} dev eth0
ip link set eth0 up
ip route replace default via ${GATEWAY}
service apache2 start
tail -F /var/log/apache2/access.log
EOF
chmod +x "$WEB_DIR/start-network.sh"
docker build -t web-server-lab "$WEB_DIR"
