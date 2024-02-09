# PM - is the simple package manager for linux (experimental)

## example to use
```sh
pm
Use: pm [option] [package_name]

Options:
    -l, l, list, --list -> list of installed packages
    -il, il, localinstall, --localinstall -> install local package
    -r, r, remove, --remove -> remove package
```
## install
```sh
cp pm.sh /usr/local/bin/pm
```
### or
```sh
cp pm.sh /usr/bin/pm
```
## package structure
```sh
-> package_name.package
    |---> usr/
    |       |---> bin
    |               |---> binary_files
    |---> rmf
    |---> rmd
    |---> install.sh

tar -czvf package_name.tar.gz package_name.package
```
## example install.sh
```sh
cp pm.package/pm.sh pm_package_manager.sh
exit 0
```
## example rmf
```sh
/usr/bin/pm
/usr/share/pm/list.pm
/usr/share/pm/pm.log
```
## example rmd
```sh
/usr/share/pm/pmpkgs
/usr/share/pm
```