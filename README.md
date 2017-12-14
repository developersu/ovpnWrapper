# ovpnWrapper

ovpnWrapper is script that creates all-in-one .ovpn file. Also generates required certificates and keys for clients.
Just give it to your clients and don't think about copying keys and certs.
If your client need client.ovpn file, client.key, ca.crt and client.crt - this app for you! If something else in addition, then no :(

## Requirements

python 3.5 or higher
EasyRSA 3 or higher. Maybe. Tested on 3.0.3.

## License

Source code spreads under the GNU General Public License v.3. You can find it in LICENSE file or just visit www.gnu.org (it should be there for sure). 

## Build & Deploy

```
$ cp ovpnWrapper.sh /path/to/easyrsa/
$ chmod +x ovpnWrapper.sh
$ vim ovpnWrapper.sh
change:
	ovpnFolder
	serverCA
	head
```
## Uninstall
```
$ rm /path/to/easyrsa/ovpnWrapper.sh
```
## Usage
```
$ ./ovpnWrapper.sh newClient
```
