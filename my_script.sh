# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    my_script.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rsaf <marvin@42.fr>                        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/12/20 05:11:00 by rsaf              #+#    #+#              #
#    Updated: 2021/12/20 17:20:00 by rsaf             ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

arch=$(uname -a)
cpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
vcpu=$(cat /proc/cpuinfo | grep "processor" | wc -l)
memory=$(free -m | grep "Mem" | awk '{print $3"/"$2 " "}')
Musage=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2*100}')

Mdisk=$(df -Bm | grep "/boot" | awk '{usedDisk += $3} {printf usedDisk}')
Gdisk=$(df -Bg | grep "/boot" | awk '{freeDisk += $2} {printf freeDisk}')
Dusage=$(df -Bm | grep "/boot" | awk '{usedDisk += $3} {freeDisk += $2} {printf("%.2f"), usedDisk/freeDisk*100}')

lastBoot=$(who -b | awk '{print $3 " " $4}')
load=$(top -bn1 | grep "%Cpu" | awk '{print $2+$4"%"}')
NBofLVM=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [$NBofLVM -eq 0]; then echo no; else echo yes; fi)
tcp=$(netstat -an | grep "ESTABLISHED" | wc -l)
log=$(users | wc -l)

ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

NBsudo=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)
wall "	#Architecture	:	$arch
	#CPU physical	:	$cpu
	#vCPU		:	$vcpu
	#Memory Usage	:	${memory}MB (${Musage}%)
	#Disk Usage	:	${Mdisk}/${Gdisk}Gb (${Dusage}%)
	#CPU load	:	$load
	#Last boot	:	$lastBoot
	#LVM use	:	$lvm
	#Connexions TCP	:	$tcp ESTABLISHED
	#User log	:	$log
	#Network	:	IP $ip ($mac)
	#Sudo		:	$NBsudo cmd"
