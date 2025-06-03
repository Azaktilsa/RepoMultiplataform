#!/bin/bash

# 🚀 1. Construir el proyecto en modo release
echo "🔨 Compilando Flutter Web en modo release..."
flutter build web

# 🚀 2. Entrar al directorio generado
cd build/web || exit

# 🚀 3. Levantar un servidor local en el puerto 8080
echo "🌐 Sirviendo el sitio en http://localhost:8080"
python3 -m http.server 8080 &

# 🚀 4. Abrir automáticamente el navegador (depende del sistema operativo)
sleep 2
if which xdg-open > /dev/null
then
  xdg-open http://localhost:8080
elif which open > /dev/null
then
  open http://localhost:8080
else
  echo "Por favor abre tu navegador en http://localhost:8080"
fi

# 🚀 5. Mensaje final
echo "✅ Proyecto desplegado localmente."
