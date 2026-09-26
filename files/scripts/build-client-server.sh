#!/bin/bash
# HISTORICAL / NOT DEPLOYED
# The image was built, but this node was never deployed in the active GNS3 topology.
# Kept only as historical reference.
set -e
CLIENT_DIR="$HOME/lab-images/client"
mkdir -p "$CLIENT_DIR"
cat > "$CLIENT_DIR/Dockerfile" <<'EOF'
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl iproute2 net-tools iputils-ping dnsutils && apt clean
ENV IP_ADDR=10.21.75.111
ENV PREFIX=25
ENV GATEWAY=10.21.75.1
COPY start-network.sh /start-network.sh
RUN chmod +x /start-network.sh
CMD ["/start-network.sh"]
EOF
cat > "$CLIENT_DIR/start-network.sh" <<'EOF'
#!/bin/bash
exec > /var/log/start-network.log 2>&1
set -e
IP_ADDR="${IP_ADDR:-10.21.75.111}"
PREFIX="${PREFIX:-25}"
GATEWAY="${GATEWAY:-10.21.75.1}"
for i in $(seq 1 15); do ip link show eth0 >/dev/null 2>&1 && break; sleep 1; done
ip addr flush dev eth0
ip addr add ${IP_ADDR}/${PREFIX} dev eth0
ip link set eth0 up
ip route replace default via ${GATEWAY}
tail -f /dev/null
EOF
chmod +x "$CLIENT_DIR/start-network.sh"
docker build -t client-pc-lab "$CLIENT_DIR"
