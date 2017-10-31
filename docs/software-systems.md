# Software Systems

Our [Superdoc](https://docs.google.com/document/d/1ZqDp1sfxVkDEsVfQ0Fsqpa6n7totzh_2IA4IrXp5i_4/edit) 
is currently our main source of information; that will slowly be migrated here.

## Comms Interfaces

* Arduino-Electrical interface: [Pinout](https://docs.google.com/spreadsheets/d/18PZNkgs89I_vvb521Zw7m2bll4Fvnhqy8EalrwVd7fA/edit#gid=1787642201)

* Raspberry Pi-Arduino interface: [Serial Comms Spec](http://htmlpreview.github.io/?https://github.com/teamwaterloop/communication-system/blob/master/communication_format.html)

* Dashboard-Raspberry Pi interface: WebSocket Comms Spec - *todo*

## Raspberry Pi setup and configuration

1. [Flash an OS onto your RPi](https://www.raspberrypi.org/documentation/installation/installing-images/).
    * We are using Raspbian because it's the best-supported RPi OS, and it has a GUI which is helpful when resolving networking problems.


2. Configure the RPi to be remotely accessible.
    * Hook up your RPi to microUSB power, a monitor, and a keyboard. Log in.
    * We are using a RPi3, so we have a Wifi module built in. If you are using an older RPi, then you might have to configure your USB Wifi dongle.
    * Connect to the Wifi, either through the GUI or by editing `/etc/network/interfaces`. Make sure it automatically connects when in range.
    * Run `sudo apt-get update`. This is just always a good thing to do after installing.
    * [Enable SSH](https://www.raspberrypi.org/documentation/remote-access/ssh/).


3. Set up a static ip on the RPi:
    * Configure DHCPD: `sudo nano /etc/dhcpcd.conf`
    * At the very bottom of the file, add the following lines:

            interface wlan0
            
            static ip_address=192.168.0.200/24
            static routers=192.168.0.1
            static domain_name_servers=192.168.0.1

    * Reboot `sudo reboot` and check that it worked `ifconfig` under wlan0 interface you should see your specified IP address.

             wlan0     Link encap:Ethernet  HWaddr 00:0F:20:CF:8B:42
                       inet addr:192.168.0.1  Bcast:217.149.127.63  Mask:255.255.255.192
                       UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                       RX packets:2472694671 errors:1 dropped:0 overruns:0 frame:0
                       TX packets:44641779 errors:0 dropped:0 overruns:0 carrier:0
                       collisions:0 txqueuelen:1000

    * **NOTE:** Wifi is being used for convenience during testing. For competition, we need to use interface `eth0`, since RPi will be connected to the SpaceX NAP.
    SpaceX allows us to use `192.168.0.6-254` inclusive. Gateway is `192.168.0.1`. DHCP and DNS are not available.


4. Remotely access the RPi.
    * You can now disconnect your RPi from the monitor and keyboard. Keep it plugged into power.
    * Run `ssh pi@<ipaddr>`. This is now a shell.


5. NodeJS should come pre-installed, but Raspbian's built-in version is very old.
    * Make sure you have npm installed properly by observing the output of `npm -v`.
    * if you got `bash: npm: command not found`, then you have to install npm first
        * `sudo apt-get install -y npm`
    * Make sure you have node installed properly by observing the output of `node -v`.
    * If your version is below 4.2, then you should update node:

            $ sudo npm cache clean -f
            $ sudo npm install -g n
            $ sudo n stable


6. Make the RPi run the server upon startup, and restart it upon crash:
    * Install the PM2 process manager globally: `sudo npm install -g pm2`
    * Run the startup configuration command provided by PM2.

            $ pm2 startup systemd
            [PM2] Init System found: systemd
            [PM2] You have to run this command as root. Execute the following command:
            <command given may vary>

    * Run the server with PM2:

            $ pm2 start server.js
            $ pm2 save

    * Now the server will start on boot, and logs can be retrieved via `pm2 logs`.
    
   
6. Clone `communication-system` repo from Github:
    * navigate to your home directory in terminal `cd ~/`
    * clone repo `git clone https://github.com/teamwaterloop/communication-system.git`
> Now you have the entire communication pipeline on RPI. Navigate to server script `cd communication-system/server`. Start it by running `pm2 start server.js`

## Deep
### Deep1
### Deep2
