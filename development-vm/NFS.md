How to mount files in your VM using NFS
=======================================

You can also export files from your mac to the VM using NFS. One advantage of this is that you can map the user ids from your mac to match those on the virtual machine.

First, install nfs-client:
  $ sudo apt-get install nfs-client

First, you need to work out the IP address of your VM. In my case it's 192.168.183.128. When you follow these examples, change YOUR_VM_IP for the ip address.

To find your VM's IP address open a terminal on your VM, e.g. using ssh, then:

    $ /sbin/ifconfig eth0 | grep -o 'inet addr:[0-9\.]*'

Second thing you need to do is find out your user id and group id on your mac:

Open a terminal on your mac and type this:

    $ id

You'll see some output like this:

    uid=501(heathd) gid=20(staff) groups=20(staff),401(com.apple.access_screensharing),101(com.apple.sharepoint.group.1),
    204(_developer),100(_lpoperator),98(_lpadmin),81(_appserveradm),80(admin),79(_appserverusr),
    61(localaccounts),12(everyone)

So I can see my uid is 501 and gid is 20. Make a note of your user id and group I'd we'll need them later.

Finally, decide what directory path you want to make available to your VM. This should be the directory where you checked out all of the code.

On your mac, you need to edit the /etc/exports file, and add a line like this

    "/path/to/alphagov/code" YOUR_VM_IP

Now you should restart NFS sharing on your mac:

  sudo nfsd restart

You should then confirm that the export has been recognised. It should show up when you do:

  showmount -e
  Exports list on localhost:
  /Users/joshua/alphagov              172.16.198.128


Now you need to find out the IP address that the VM thinks your mac is on. I suggest doing this on your mac:

  $ ifconfig vmnet8
  vmnet8: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
    ether 00:50:56:c0:00:08 
    inet 172.16.30.1 netmask 0xffffff00 broadcast 172.16.30.255

The IP address is 172.16.30.1, we'll refer to this as YOUR_MAC_IP below. 

Note: vmnet8 corresponds to VMWare's NAT based networking. The exact network will depend on how you set up networking in vmware.

Now ssh onto your vm.

  $ ssh 172.16.198.128

And you need to edit the file /etc/fstab and add a line like this:

   YOUR_MAC_IP:/Users/heathd/alphagov /home/heathd/alphagov   nfs   timeo=14,intr 0 0


Advanced: edit your user id to be the same as your Mac user id
