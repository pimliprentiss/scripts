#!/bin/bash 

#Simple scripts for connecting to OpenVPN. Must set ( preferably export) enviroment variable VPNPASS with the value of your vpn password.
#This script handles the importing of  your vpn config file, adjust variable names to your specifications.

USER='Your_username' 
CONFIGPATH="$HOME/vpn/client.ovpn"
CONFIGNAME="ntvpn"



if [[ $1  != '-d' && $1 != '-c' && $1 != '-l' && $1 != '-r' ]]; then
  echo "No sabes tu que tienes que pasar -c pa conectarte, -d pa salir, -r para reiniciar  o -l pa ver klok?"
  exit 1
fi

if [[ $1 == '-c' ]]; then
#Checks if config file has already been imported since last restart in order to avoid duplicates.
  openvpn3 configs-list | grep -q $CONFIGNAME
  if [[ $? != 0 ]]; then openvpn3 config-import --config $CONFIGPATH --name $CONFIGNAME; fi 

#Checks for existing sessions in order to avoid duplicates.
  openvpn3 sessions-list | grep -q $CONFIGNAME
  if [[ $? == 0 ]]; then echo "Cuantas veces te va a conectar?" && exit 1; fi 

  printf "$USER\n$VPNPASS" | openvpn3 session-start --config $CONFIGNAME

elif [[ $1 == '-d' ]]; then
  openvpn3 session-manage --disconnect --config $CONFIGNAME
elif [[ $1 == '-r' ]]; then
  openvpn3 sessions-list | grep -q $CONFIGNAME
  if [[ $? != 0 ]]; then echo "Pero conectate primero, mmg" && exit 1; fi 
  openvpn3 session-manage --disconnect --config $CONFIGNAME
  printf "$USER\n$VPNPASS" | openvpn3 session-start --config $CONFIGNAME
else 
  openvpn3 sessions-list
fi  
