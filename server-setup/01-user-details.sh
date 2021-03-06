#!/bin/bash

echo "$(tput setaf 1)#########################################################################"
echo "$(tput setaf 2)Setting Up User$(tput setaf 1)"
echo "#########################################################################$(tput setaf 7)"

username="dev"
password=$(generatePassword)

adduser -p "$password" $username

echo "Username: " $username >> ./emailFile.txt
echo "Password: " $password >> ./emailFile.txt

sshConfigFile="/etc/ssh/sshd_config"

replaceInFile "#AuthorizedKeysFile.*" "AuthorizedKeysFile      %h\/.ssh\/authorized_keys" $sshConfigFile
replaceInFile "PermitRootLogin yes" "PermitRootLogin no" $sshConfigFile
replaceInFile "PasswordAuthentication yes" "PasswordAuthentication no" $sshConfigFile
replaceInFile "#PubkeyAuthentication yes" "PubkeyAuthentication yes" $sshConfigFile

#Create the .ssh folder
mkdir "/home/$username/.ssh"
chmod 700 "/home/$username/.ssh"
chown $username "/home/$username/.ssh"

#Create the file to store the certificate
touch "/home/$username/.ssh/authorized_keys"
chmod 600 "/home/$username/.ssh/authorized_keys"
chown $username "/home/$username/.ssh/authorized_keys"

cat server-setup/ssh/publickey.txt > "/home/$username/.ssh/authorized_keys"

enableService sshd