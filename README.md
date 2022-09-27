Fan Speed Monitor
---------------
Plasma 5 applet for monitoring Fan Speed sensors.

Coding very largely based off of Kotelnik's https://github.com/kotelnik/plasma-applet-thermal-monitor.

Original Icon is Fan Icon made by Freepik from www.flaticon.com (https://www.flaticon.com/free-icon/fan_22846) before changing the colors.

### BUILD DEPENDENCIES 
cmake, make, extra-cmake-modules, plasma-dev (or plasma-framework-devel or whatever your distro calls it)

### RUN DEPENDENCIES
ksysguard (or else no sensors are available)


### INSTALLATION

```sh
$ git clone --depth=1 https://github.com/dwardor/plasma-applet-fanspeed-monitor
$ cd plasma-applet-fanspeed-monitor/
$ mkdir build
$ cd build
$ cmake .. -DCMAKE_INSTALL_PREFIX=/usr
$ sudo make install
```

### UNINSTALLATION

```sh
$ cd plasma-applet-fanspeed-monitor/build/
$ sudo make uninstall
```
or
```sh
$ sudo rm -r /usr/share/plasma/plasmoids/org.kde.fanspeedMonitor
$ sudo rm /usr/share/kservices5/plasma-applet-org.kde.fanspeedMonitor.desktop
```
### LICENSE
This project is licensed under the [GNU General Public License v2.0](https://www.gnu.org/licenses/gpl-2.0.html) and is therefore Free Software. A copy of the license can be found in the [LICENSE file](LICENSE).
