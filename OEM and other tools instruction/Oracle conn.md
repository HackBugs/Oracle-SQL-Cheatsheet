> # **Oracle Linux / RHEL VM me network troubleshoot and setup useful Linux commands** in **bash code block**
---

```bash
###############################################
# Oracle Linux VM Network Debug & Ping Fix
###############################################

# 1. Check current IP address and interface status
ip a

# 2. Check if NetworkManager is running
sudo systemctl status NetworkManager

# 3. Start and enable NetworkManager (if not running)
sudo systemctl enable NetworkManager --now

# 4. Show active network connections
nmcli connection show

# 5. Bring interface down and up again
sudo nmcli connection down enp0s3
sudo nmcli connection up enp0s3

# 6. Restart network service (for older versions)
sudo systemctl restart network

# 7. Stop and disable firewalld (for ping test)
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 8. Check if ICMP ping packets are received
sudo tcpdump -i enp0s3 icmp

# 9. View ARP table entries
arp -a

# 10. Check SELinux status
sestatus

# 11. Check iptables rules (optional, if ping still blocked)
sudo iptables -L

# 12. Edit manual static IP config (ifcfg-enp0s3 file)
sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3

# Example content for static IP (inside that file):
# --------------------------------------------
# TYPE=Ethernet
# BOOTPROTO=static
# NAME=enp0s3
# DEVICE=enp0s3
# ONBOOT=yes
# IPADDR=192.168.1.124
# PREFIX=24
# GATEWAY=192.168.1.1
# DNS1=8.8.8.8
# --------------------------------------------

# 13. Apply new network config
sudo systemctl restart network

# 14. From host system, try to ping the VM
ping 192.168.1.124
```

---

### 💾 Tip: Save this to a file

You can save it on your Linux VM:

```bash
nano ~/vm_network_fix.sh
```

Paste the above content, then save with `CTRL+O`, exit with `CTRL+X`.

<hr>

> # **complete Linux command sheet (all categories)** — in **bash-style** 

---

## 🧾 **Linux All-in-One Command Cheatsheet**

📄 Save this file in `.sh` ya `.txt` format for reference.

```bash
##############################################
# 🔧 1. Basic System Info & Hardware
##############################################
uname -a                   # Kernel & OS info
hostnamectl                # Hostname and OS info
uptime                     # System uptime
free -h                    # RAM usage
df -h                      # Disk usage
lsblk                      # Block devices
lscpu                      # CPU info

##############################################
# 👤 2. User & Group Management
##############################################
adduser myuser             # Add user
passwd myuser              # Set password
usermod -aG wheel myuser   # Add user to sudo group
id myuser                  # User info
groups myuser              # Groups of user
deluser myuser             # Delete user
groupadd devs              # Create new group
groupdel devs              # Delete group

##############################################
# 📦 3. Package Management (RHEL/CentOS)
##############################################
yum update -y              # Update all packages
yum install nano -y        # Install package
yum remove nano -y         # Remove package
yum list installed         # List installed packages

# 📦 Ubuntu/Debian equivalent:
apt update && apt upgrade -y
apt install nano -y
apt remove nano -y

##############################################
# ⚙️ 4. Service & Systemd Management
##############################################
systemctl status sshd      # Check service status
systemctl start nginx      # Start service
systemctl stop nginx       # Stop service
systemctl restart nginx    # Restart service
systemctl enable nginx     # Enable on boot
systemctl disable nginx    # Disable on boot

##############################################
# 🌐 5. Networking
##############################################
ip a                       # Show IP addresses
nmcli connection show      # Show network connections
systemctl restart network  # Restart network service
ping 8.8.8.8               # Test internet
ping <host-ip>             # Ping another machine
netstat -tuln              # Show open ports (install: net-tools)
ss -tuln                   # Alternative to netstat

##############################################
# 🔐 6. Firewall & SELinux
##############################################
systemctl stop firewalld   # Stop firewall
systemctl disable firewalld# Disable firewall
sestatus                   # Check SELinux status
getenforce                 # Get SELinux mode
setenforce 0               # Set SELinux to permissive (temp)

##############################################
# 📁 7. File & Directory Management
##############################################
ls -lh                     # List files with size
cd /etc                   # Change directory
mkdir myfolder             # Create folder
touch myfile.txt           # Create file
rm -rf myfolder            # Remove folder
cp file1.txt /tmp/         # Copy file
mv file1.txt file2.txt     # Rename/move file

##############################################
# 📋 8. Process Management
##############################################
ps aux                     # All running processes
top                        # Real-time processes
htop                       # (Install first) Better top view
kill -9 <PID>              # Force kill process
pkill nginx                # Kill all nginx processes

##############################################
# 🔁 9. System Reboot/Shutdown
##############################################
reboot                     # Reboot system
shutdown now               # Shutdown immediately
shutdown -r +5             # Reboot in 5 mins

##############################################
# 🐳 10. Docker (Basics)
##############################################
docker --version           # Check Docker version
docker ps -a               # All containers
docker images              # List images
docker run -it ubuntu bash# Run Ubuntu container
docker stop <id>           # Stop container
docker rm <id>             # Remove container
docker rmi <image>         # Remove image

##############################################
# 🐙 11. Git (Basic)
##############################################
git init                   # Initialize repo
git clone <url>            # Clone repo
git add .                  # Add changes
git commit -m "msg"        # Commit
git push                   # Push to remote
git pull                   # Pull latest

##############################################
# 📂 12. Archiving & Compression
##############################################
tar -cvf myarchive.tar dir/     # Create tar
tar -xvf myarchive.tar          # Extract tar
tar -czvf file.tar.gz dir/      # Tar + gzip
gzip file.txt                   # Compress file
gunzip file.txt.gz              # Decompress

##############################################
# 🧪 13. Misc Utilities
##############################################
history                   # Show previous commands
clear                     # Clear screen
date                      # Show date & time
cal                       # Calendar
uptime                    # How long system is up
whoami                    # Current user

##############################################
# 🔐 14. SSH & SCP
##############################################
ssh user@remote-ip               # SSH login
scp file.txt user@remote:/path/ # Copy file to remote
scp user@remote:/file.txt ./    # Copy file from remote

##############################################
# 🧠 15. Monitoring & Logging
##############################################
journalctl -xe                # System logs
tail -f /var/log/messages     # Live logs
dmesg                         # Boot/kernel messages

##############################################
# 🌍 16. Networking Tools
##############################################
curl ifconfig.me              # Show public IP
traceroute google.com         # Route tracing
dig google.com                # DNS info (install: bind-utils)
```

---

## 💡 How to Save This File:

1. On your VM or host system:

   ```bash
   nano linux_cheatsheet.sh
   ```

2. Paste the full content, then:

   * Press `Ctrl + O` → Save
   * Press `Ctrl + X` → Exit

You can even keep it in GitHub, Notion, or local Notepad++ for future use ✅

---

