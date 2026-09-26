#!/bin/bash
# =============================================================
# build-browser-gns3vnc.sh
# Contenedor minimo con Firefox, sin Xvfb ni x11vnc propios.
# GNS3 inyecta su propio Xvfb+x11vnc cuando console_type = vnc.
#
# Direccionamiento: 10.21.75.110/25, gateway 10.21.75.1
#
# Ejecutar dentro de la GNS3 VM (por SSH).
# Uso: bash build-browser-gns3vnc.sh
# =============================================================
set -e

DIR="$HOME/lab-images/browser-vnc"
mkdir -p "$DIR"

echo "[1/3] Generando Dockerfile ..."
cat > "$DIR/Dockerfile" <<'EOF'
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y firefox-esr iproute2 net-tools iputils-ping && apt clean

ENV IP_ADDR=10.21.75.110
ENV PREFIX=25
ENV GATEWAY=10.21.75.1

COPY start-network.sh /start-network.sh
RUN chmod +x /start-network.sh
CMD ["/start-network.sh"]
EOF

echo "[2/3] Generando start-network.sh ..."
cat > "$DIR/start-network.sh" <<'EOF'
#!/bin/bash
exec > /var/log/start-network.log 2>&1
set -e

IP_ADDR="${IP_ADDR:-10.21.75.110}"
PREFIX="${PREFIX:-25}"
GATEWAY="${GATEWAY:-10.21.75.1}"

echo ">> Esperando a que eth0 exista..."
for i in $(seq 1 15); do
  ip link show eth0 >/dev/null 2>&1 && break
  sleep 1
done

echo ">> Browser-PC: configurando eth0 con ${IP_ADDR}/${PREFIX}, gateway ${GATEWAY}"
ip addr flush dev eth0
ip addr add ${IP_ADDR}/${PREFIX} dev eth0
ip link set eth0 up
ip route replace default via ${GATEWAY}

echo ">> Lanzando Firefox (GNS3 debe inyectar su propio Xvfb+x11vnc via consola VNC)"
exec firefox-esr --no-remote --new-instance
EOF
chmod +x "$DIR/start-network.sh"

echo "[3/3] Construyendo imagen browser-gns3vnc-lab ..."
docker build -t browser-gns3vnc-lab "$DIR"

echo "Listo:"
docker images | grep browser-gns3vnc-lab
