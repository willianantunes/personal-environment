function do_stuff_for_virtual_machines() {
  echo "<<<<<< Stuff for virtual machines"

  read -r -p "<<<<<<<<<<<< Apply stuff for VM if needed? " response

  if [[ "$response" =~ $YES_REGEXP ]]; then
    systemManufacturer=$(dmidecode -s system-manufacturer)

    if [[ $systemManufacturer=*"VMware"* ]] || [[ $systemManufacturer=*"VirtualBox"* ]]; then
      echo "<<< It's a VM!"
      sudo apt install open-vm-tools-desktop
    fi
  fi
}
