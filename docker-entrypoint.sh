#!/bin/bash

cd /opt/nxreporting

java -jar ./reporting-server-3.5.90.jar
while sleep 150
do
   echo "segurando as pontas"
done
