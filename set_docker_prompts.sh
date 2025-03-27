#!/bin/bash

echo "🔎 Ustawianie promptów w kontenerach Docker..."

for container in $(docker ps --format '{{.Names}}'); do
  echo "➡️  Kontener: $container"

  if docker exec "$container" which bash >/dev/null 2>&1; then
    echo "   ✅ Wykryto bash – dodaję prompt do /root/.bashrc"
    docker exec --user root "$container" bash -c 'echo '\''export PS1="[DOCKER-'$container'] \u@\h:\w\$ "'\'' >> /root/.bashrc'
  
  elif docker exec "$container" which sh >/dev/null 2>&1; then
    echo "   ✅ Wykryto sh – dodaję prompt do /root/.profile"
    docker exec --user root "$container" sh -c 'echo "export PS1=\"[DOCKER-'$container'] \u@\h:\w\$ \"" >> /root/.profile'
  
  else
    echo "   ⚠️  Brak bash/sh – pomijam ($container)"
  fi
done

echo "✅ Gotowe."
