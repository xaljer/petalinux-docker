#!/usr/bin/env bash
installer_dir=$1
docker_context=`pwd`

echo "Start to build petalinux tools docker image ..."
echo "-----------------------------------------------"

cd $installer_dir
python3 -m http.server &
server_pid=$!

cd $docker_context
installer_ip=`ifconfig docker0 | grep 'inet\s' | awk '{print $2}'`
docker build -t petalinux-docker:2014.4 \
             --build-arg installer_url=${installer_ip}:8000 \
             .

kill $server_pid
echo "---------------"
echo "  Finish. ^_^  "
echo "---------------"
