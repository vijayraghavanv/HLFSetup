# HLFSetup
Set of batch files for a single button install of HLF
Note: This works only on Ubuntu 14.04 and above.
Scenario: This installation assumes a two node setup across two disparate servers. Out of these two servers, one server will be the primary (Where the orderer runs) and the second server is secondary (Runs only peer process).
Further, only one peer per node is installed using this method.
If these constraints seem ok to you, move to the next step....
You will need the following:
  1. Two servers (Ideally created in one of the cloud providers - Bare minimum instance on AWS will suffice - t2.nano equivalent or 1 vCPU and half a gig RAM). You need the IP addresses of these two servers (Public IPs). You would also need the private key that is used for accessing these servers.
  2. Ensure that ports 7050-7060 are open. Check HLF documentation if you need couchDB ports also open.
  3. Just opening the ports wont suffice, you would need to add appropriate rules in the iptables. But worry not, this is automatically done for you.
 Steps to follow:
  1. Login to the primary server and create a folder called scripts (This should be as follows: - /home/ubuntu/scripts).
  2. Copy RectifyLocale.sh, setupBlockChainBasics.sh, setupBlockChainNetwork.sh and sshc.sh to the scripts folder.
  3. Also copy secondary server's private key to this folder (I know that this is a security lapse...however I choose to overlook this issue). Change permission (chmod 400 id_rsa).
  4. cd ~/scripts
  5. chmod +x *
  6. Run rectifyLocale.sh - This is mandatory if you keep getting those pesky LC_ALL and LANGUAGE charset not set.
  7. ./setupBlockChainBasics.sh BlockChainName BlockchainVersion OrgChoice primaryOrgName secondaryOrgName secondaryOrgIP pathtosecondaryorgpvtkey channelName channelProfile
    a) BlockChainName is currently not used, but needs to be provided for the time being.
    b) Ensure that channelName does not have capital letters.
    c) BlockChainVersion : All versions from 1.0.0 are supported. The acceptable values are:
        1.0.0' '1.0.1' '1.0.2' '1.0.3' '1.0.4' '1.0.5' '1.0.6' '1.1.0-alpha' '1.1.0-preview and '1.1.0-rc1'
        Note: HLF seems to have changed the location where Version details are stored from 1.1.0-rc1. The script automatically takes that into account
  8. You can tail install.log on the secondary server.
        
  That's about it. Grab a coffee and you should have a fully functional HLF setup to deploy chaincodes after roughly 6 minutes.
  Issues:
  1. script hangs - This is possibly because of menu.lst being upgraded. Though a non-interactive mode has been forced, it appears that not all distros behave in the same way. If it happens, do the following:
    run dpkg-reconfigure debconf (Or whatever command ubuntu asks you to run). Do a sudo apt-get update and sudo apt-get upgrade manually. Rerun the script after a reboot.
  2. You get a message that request times out on secondary when it tries to fetch the genesis block from the primary - Most likely your firewall is the culprite. Try with iptables -F temporarily to check. Rerun the script. If it works, add the ports to iptables manually (Normally this shouldnt be the case as the script takes care to open the appropriate ports in IPTables.Also check if the security list in your cloud provider allow access to the port.
  
