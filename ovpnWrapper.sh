#!/usr/bin/python3.5
#************************************************
#* Name: ovpnWrapper                            *
#* Author: Dmitry Isaenko                       *
#* License: GNU GPL v.3                         *
#* Version: 0.1                                 *
#* Site: https://developersu.blogspot.com/      *
#* 2017, Russia                                 *
#************************************************

import sys
import os
import subprocess

# Define folder to store prepared .ovpn files
ovpnFolder = os.environ['HOME']+"/ovpn/"        # Replace to 'ovpnFolder = "/path/to/dir"'

# Define CA location
#serverCA = 'pki/private/ca.crt'
serverCA = '/etc/openvpn/server/ca.crt'

# Define values for each .ovpn file
head = "\
client                                     \n\
tls-client                                 \n\
dev tun                                    \n\
proto udp                                  \n\
remote your.host.name.located.here.! 1194  \n\
cipher AES-256-CBC                         \n\
resolv-retry infinite                      \n\
nobind                                     \n\
persist-tun                                \n\
persist-key                                \n\
verb 3                                     \n\
"
###    WORKING ROUTINE. Don't touch if not sure.
def main():
    if (len(sys.argv) == 1) or (len(sys.argv) > 2):
        print('Usage: ./ovpnWrapper file_name')
        return -1
    else:
        fileName = sys.argv[1]
    # Check that this script located in same folder with EasyRSA 
    if not os.path.exists('./easyrsa'):
        print('./easyrsa executable not found. Please move this script to EasyRSA folder before start.')
        return -1
    # Check/create folder to store .ovpn files
    if not os.path.exists(ovpnFolder):
        os.makedirs(ovpnFolder)
    # Check that CA exists
    if os.path.exists(serverCA):
        ca = open(serverCA, 'r')
    else:
        print('CA file not found at:'+serverCA)
        return -1
    # Generate client certificate and key
    clientCRT = './pki/issued/'+fileName+'.crt'
    clientKEY = './pki/private/'+fileName+'.key'

    if (not os.path.exists(clientKEY)) and (not os.path.exists(clientCRT)):
        print('Creating new client key')
        if not subprocess.call(['./easyrsa', 'build-client-full', fileName, 'nopass']):
            print('EasyRSA execution failed')
            print('But we don\'t give up and continue routines. Probably one day EasyRSA fix this issue and I could replace this string by \"return -1\"')
        if (not os.path.exists(clientKEY)) and (not os.path.exists(clientCRT)):
            print('Somehow certificate and key not found. Ideas?')
            return -1
    else:
        print('Using existing client certificate & key')

    crt = open(clientCRT,'r')
    key = open(clientKEY,'r')
    # Write to .ovpn file
    ovpn = open(ovpnFolder+sys.argv[1]+'.ovpn', 'w')
    ovpn.write(head)
    ovpn.writelines('<ca>\n')
    for line in ca:
        ovpn.writelines(line)
    ovpn.writelines('</ca>\n')
    ovpn.writelines('<cert>\n')
    for line in crt:
        if '-----BEGIN CERTIFICATE-----' in line:        # seek to line where actual cert begins
            ovpn.writelines(line)
            for line in crt:
                ovpn.writelines(line)
    ovpn.writelines('</cert>\n')
    ovpn.writelines('<key>\n')
    for line in key:
        ovpn.writelines(line)
    ovpn.writelines('</key>\n')

    ca.close()
    crt.close()
    key.close()
    ovpn.close()
    return 0

if __name__ == "__main__":
    sys.exit(main())

