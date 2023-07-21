#!/bin/bash

export CONFIG_FILE_NAME="maria.cfg"
export CONFIG_NAME=""
export CONFIG_VALUE=""
export SERVER_ROLE="NONE"
export GLOBAL_HIGH_AVAILABLITY_YN=""
export PRIMARY_MASTER_PRIVATE_IP=""
export PRIMARY_SLAVE_PRIVATE_IP=""
export SECONDARY_MASTER_PRIVATE_IP=""
export SECONDARY_SLAVE_PRIVATE_IP=""
export PRIMARY_HIGH_AVAILABLITY_YN=""
export SECONDARY_HIGH_AVAILABLITY_YN=""
export SKIP="N"
export G_COMM=""
export CLUSTER_NAME=""
export NODE_ADDRESS=""
export NODE_NAME=""
export DB_ONLY_SERVER="N"
export OPTION_lower_case_table_names="0"
export OPTION_innodb_buffer_pool_size="256M"
export OPTION_W_GCACHE_SIZE="256M"
export OPTION_W_GCACHE_PAGE_SIZE="128M"
export CRONTAB_DB_BACKUP="N"
export CHECK_RESULT=""
export LENGTH="0"

declare -A CONFIG_ARRAY

func_os_version()
{
	EL8_CHK="`uname -r | grep "el8"`"
	if [ -n "$EL8_CHK" ];then
		OS_VER="8"
	fi
	EL9_CHK="`uname -r | grep "el9"`"
	if [ -n "$EL9_CHK" ];then
		OS_VER="9"
	fi
}

# Change directory to the directory where the script file is located.
cd $(dirname "$0")

echo "---------------------------------------------------------"
echo " Rocky 8 - MariaDB v10.4 Install "
echo "---------------------------------------------------------"

# OS Version Check  ( Rocky 8 Only )
func_os_version
if [ "$OS_VER" -ne "8" ];then
	echo ""
	echo "### OS Version is NOT 8 (version:$OS_VER) ###"
	echo ""
	echo ""
	exit;
fi 

# Select server type
echo
echo "-- Select Server Type --"
echo
echo "1) EMS-DB"
echo "2) OMS-DB"
echo "3) Others (Feature/SBC-Signal/FAX)"
echo

while [ 1 ] 
do
	echo -n "Select Server Type : "
	read MENU

	case "$MENU" in
		[a-zA-Z]*   ) echo "[ERROR] Input string'$MENU'"; continue;;  	# 문자로 시작하는지.
		""          ) echo "[ERROR] Input space";         continue;;	# 공백인지
		*	    	) break;
	esac
	
	break;
done

MENU=`echo $MENU | sed s/" "//g`
if [ $MENU -lt 1 ] || [ $MENU -gt 3 ];then
	echo $MENU is not in menu
	exit
fi

case $MENU in
	1) 
		DB_ONLY_SERVER="Y"
		CRONTAB_DB_BACKUP="Y"
		OPTION_lower_case_table_names="0";;
	2) 
		DB_ONLY_SERVER="Y"
		OPTION_lower_case_table_names="1";;
	3) 
		DB_ONLY_SERVER="N"
		OPTION_lower_case_table_names="0";;
	*) echo $MENU is not in menu
esac

# Select system memory
echo
echo "-- Select System Memory  --"
echo
echo "1) Less than 2GB"
echo "2) 2GB ~ 4GB"
echo "3) 4GB ~ 6GB"
echo "4) 6GB ~ 8GB"
echo "5) 8GB ~ 10GB"
echo "6) 10GB ~ 12GB"
echo "7) 12GB or More"
echo

while [ 1 ] 
do
	echo -n "Select System Memory : "
	read MENU2

	case "$MENU2" in
		[a-zA-Z]*   ) echo "[ERROR] Input string'$MENU2'"; 	continue;;	# 문자로 시작하는지.
		""          ) echo "[ERROR] Input space";         	continue;;	# 공백인지 
		*	    	) break;
	esac
	
	break;
done

MENU2=`echo $MENU2 | sed s/" "//g`
if [ $MENU2 -lt 1 ] || [ $MENU2 -gt 7 ];then
	echo $MENU2 is not in menu
	exit
fi

case $MENU2 in
	1)	# Less than 2GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="256M"
			OPTION_W_GCACHE_SIZE="256M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		else
			OPTION_innodb_buffer_pool_size="128M"
			OPTION_W_GCACHE_SIZE="256M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	2)	# 2GB ~ 4GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="512M"
			OPTION_W_GCACHE_SIZE="512M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		else
			OPTION_innodb_buffer_pool_size="256M"
			OPTION_W_GCACHE_SIZE="256M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	3)	# 4GB ~ 6GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="2G"
			OPTION_W_GCACHE_SIZE="512M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		else
			OPTION_innodb_buffer_pool_size="512M"
			OPTION_W_GCACHE_SIZE="256M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	4)	# 6GB ~ 8GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="3G"
			OPTION_W_GCACHE_SIZE="1G"
			OPTION_W_GCACHE_PAGE_SIZE="256M"
		else
			OPTION_innodb_buffer_pool_size="1G"
			OPTION_W_GCACHE_SIZE="512M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	5)	# 8GB ~ 10GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="4G"
			OPTION_W_GCACHE_SIZE="1G"
			OPTION_W_GCACHE_PAGE_SIZE="256M"
		else
			OPTION_innodb_buffer_pool_size="2G"
			OPTION_W_GCACHE_SIZE="512M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	6)	# 10GB ~ 12GB
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="6G"
			OPTION_W_GCACHE_SIZE="1G"
			OPTION_W_GCACHE_PAGE_SIZE="256M"
		else
			OPTION_innodb_buffer_pool_size="3G"
			OPTION_W_GCACHE_SIZE="512M"
			OPTION_W_GCACHE_PAGE_SIZE="128M"
		fi;;
	7)	# 12GB or More
		if [ "$DB_ONLY_SERVER" == "Y" ];then
			OPTION_innodb_buffer_pool_size="7G"
			OPTION_W_GCACHE_SIZE="2G"
			OPTION_W_GCACHE_PAGE_SIZE="256M"
		else
			OPTION_innodb_buffer_pool_size="4G"
			OPTION_W_GCACHE_SIZE="1G"
			OPTION_W_GCACHE_PAGE_SIZE="256M"
		fi;;
	*) echo $MENU2 is not in menu
esac
echo

# Check if the configuration file is valid.
if [ -e $CONFIG_FILE_NAME ] && [ -f $CONFIG_FILE_NAME ] && [ -s $CONFIG_FILE_NAME ]
then
	echo ""
else
	echo "CONFIG FILE [$CONFIG_FILE_NAME] error"
	exit
fi

# To read a configuration file and store the values into variables.
echo "From maria.cfg"
echo 
while read line	|| [[ -n "$line" ]]
do			
	# Skip if it starts with "[".
	if [ `echo ${line:0:1}` == '['  ]; then
		continue;
	fi
		
	CONFIG_NAME=`echo $line | awk -F = '{ gsub(/[ \t\r\n]/, "", $1); print $1 }'`
	CONFIG_VALUE=`echo $line | awk -F = '{ gsub(/[ \t\r\n]/, "", $2);print $2 }'`
	
	#  Skip if it's empty line
	if [ -z $CONFIG_NAME ];	then
		continue;
	fi	
	
	# If it ends with "IP"
	if [[ "$CONFIG_NAME" == *"IP" ]] &&  [ -n "$CONFIG_VALUE" ]; then
		# Check IP value
		CHECK_RESULT=$((ipcalc -c $CONFIG_VALUE) 2>&1)
		LENGTH=${#CHECK_RESULT}
		if [ $LENGTH != "0"  ]; the                             n
			echo "[$CONFIG_NAME] value ip format error [${CONFIG_ARRAY[$CONFIG_NAME]}]"
			exit;
		fi
		
		echo "$CONFIG_NAME=[$CONFIG_VALUE]"
		
	# If it ends with "YN"
	elif [[ "$CONFIG_NAME" == *"YN" ]] &&  [ -n "$CONFIG_VALUE" ]; then
		# Check YN value
		if [ "$CONFIG_VALUE" != "Y" ] && [ "$CONFIG_VALUE" != "N" ]; then
			echo "[$CONFIG_NAME] value [Y/N] error [${CONFIG_ARRAY[$CONFIG_NAME]}]"
			exit;
		fi
		
		echo "$CONFIG_NAME=[$CONFIG_VALUE]"			
	fi
	
	CONFIG_ARRAY[$CONFIG_NAME]=$CONFIG_VALUE
done < "$CONFIG_FILE_NAME"
	
PRIMARY_MASTER_PRIVATE_IP="${CONFIG_ARRAY[PRIMARY_MASTER_PRIVATE_IP]}"
PRIMARY_SLAVE_PRIVATE_IP="${CONFIG_ARRAY[PRIMARY_SLAVE_PRIVATE_IP]}"
SECONDARY_MASTER_PRIVATE_IP="${CONFIG_ARRAY[SECONDARY_MASTER_PRIVATE_IP]}"
SECONDARY_SLAVE_PRIVATE_IP="${CONFIG_ARRAY[SECONDARY_SLAVE_PRIVATE_IP]}"
PRIMARY_HIGH_AVAILABLITY_YN="${CONFIG_ARRAY[PRIMARY_HIGH_AVAILABLITY_YN]}"
SECONDARY_HIGH_AVAILABLITY_YN="${CONFIG_ARRAY[SECONDARY_HIGH_AVAILABLITY_YN]}"
GLOBAL_HIGH_AVAILABLITY_YN="${CONFIG_ARRAY[GLOBAL_HIGH_AVAILABLITY_YN]}"	

CLUSTER_NAME=$PRIMARY_MASTER_PRIVATE_IP;

# Check if the appropriate value has been entered.
# Check the value of "SKIP".
if [[ "$SKIP" == "Y" ] && [ "$SKIP" == "N" ]]; then
	echo "Check if the variable 'SKIP' has been entered correctly."
	exit;
fi

# Check the value of IP
if [ "$PRIMARY_MASTER_PRIVATE_IP" == "" ]; then
	echo "PRIMARY_MASTER_PRIVATE_IP is empty."
	exit;
fi

if [ "$PRIMARY_HIGH_AVAILABLITY_YN" == "Y" ]; then
	if [ "$PRIMARY_SLAVE_PRIVATE_IP" == "" ]; then
		echo "PRIMARY_SLAVE_PRIVATE_IP is empty."
		exit;
	fi
else
	if [ "$PRIMARY_SLAVE_PRIVATE_IP" != "" ]; then
		echo "PRIMARY_SLAVE_PRIVATE_IP should be empty."
		exit;	
	fi
fi

if [ "$GLOBAL_HIGH_AVAILABLITY_YN" == "Y" ]; then
	if [ "$SECONDARY_MASTER_PRIVATE_IP" == "" ]; then
		echo "SECONDARY_MASTER_PRIVATE_IP is empty"
		exit;
	fi
else
	if [ "$SECONDARY_MASTER_PRIVATE_IP" != "" ]; then
		echo "SECONDARY_MASTER_PRIVATE_IP should be empty"
		exit;
	fi  
fi
	
if [ "$SECONDARY_HIGH_AVAILABLITY_YN" == "Y" ]; then
	if [ "$SECONDARY_SLAVE_PRIVATE_IP" == "" ]; then
		echo "SECONDARY_SLAVE_PRIVATE_IP is empty"
		exit;
	fi
else
	if [ "$SECONDARY_SLAVE_PRIVATE_IP" != "" ];	then
		echo "SECONDARY_SLAVE_PRIVATE_IP should be empty"
		exit;
	fi
fi

# Determine the type of server based on the obtained IP
ifconfig > ip_temp

while read line; do	
	echo $line | grep "inet" | grep -v "inet6" | awk '{ print $2 }' >> ip_list
done < ip_temp

while read line; do
	case "$line" in
		"$PRIMARY_MASTER_PRIVATE_IP")
			SERVER_ROLE="PA";
			NODE_ADDRESS="$PRIMARY_MASTER_PRIVATE_IP"
			break
			;;
		"$PRIMARY_SLAVE_PRIVATE_IP")
			SERVER_ROLE="PS";
			NODE_ADDRESS="$PRIMARY_SLAVE_PRIVATE_IP"
			break
			;;
		"$SECONDARY_MASTER_PRIVATE_IP")
			SERVER_ROLE="SA";
			NODE_ADDRESS="$SECONDARY_MASTER_PRIVATE_IP"
			break
			;;
		"$SECONDARY_SLAVE_PRIVATE_IP")
			SERVER_ROLE="SS";
			NODE_ADDRESS="$SECONDARY_SLAVE_PRIVATE_IP"
			break
			;;
	esac
done < ip_list

rm -f ip_temp ip_list

if [ $SERVER_ROLE == "NONE" ]; then
	echo "Check if IP has been entered correctly."
	exit;
else
	echo "SERVER_ROLE=$SERVER_ROLE"
	echo "NODE_ADDRESS=$NODE_ADDRESS"
fi
NODE_NAME="$NODE_ADDRESS"

# Set the MARIA DB CLUSTER configuration IP variables using the input IP information.
if [ $SERVER_ROLE == "PA" ]; then
	if [ -n "$PRIMARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$PRIMARY_SLAVE_PRIVATE_IP"
	fi

	if [ -n "$SECONDARY_MASTER_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_MASTER_PRIVATE_IP"
	fi

	if [ -n "$SECONDARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_SLAVE_PRIVATE_IP"
	fi
fi

if [ $SERVER_ROLE == "PS" ]; then
	if [ -n "$PRIMARY_MASTER_PRIVATE_IP" ];	then
		G_COMM="$PRIMARY_MASTER_PRIVATE_IP"
	fi

	if [ -n "$SECONDARY_MASTER_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_MASTER_PRIVATE_IP"
	fi
	
	if [ -n "$SECONDARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_SLAVE_PRIVATE_IP"
	fi
fi

if [ $SERVER_ROLE == "SA" ]; then
	if [ -n "$PRIMARY_MASTER_PRIVATE_IP" ]; then
		G_COMM="$PRIMARY_MASTER_PRIVATE_IP"
	fi

	if [ -n "$PRIMARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$PRIMARY_SLAVE_PRIVATE_IP"
	fi
	
	if [ -n "$SECONDARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_SLAVE_PRIVATE_IP"
	fi
fi

if [ $SERVER_ROLE == "SS" ]; then
	if [ -n "$PRIMARY_MASTER_PRIVATE_IP" ]; then
		G_COMM="$PRIMARY_MASTER_PRIVATE_IP"
	fi

	if [ -n "$PRIMARY_SLAVE_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$PRIMARY_SLAVE_PRIVATE_IP"
	fi
	
	if [ -n "$SECONDARY_MASTER_PRIVATE_IP" ]; then
		G_COMM="$G_COMM,$SECONDARY_MASTER_PRIVATE_IP"
	fi
fi 

G_COMM=${G_COMM/%,}
echo "G_COMM=$G_COMM"

while true; do
	echo
	echo "[WARNNING]"
	echo -n "Would you like to reinstall? (Y/N) "
	read CONTINUE
	
	if [ "$CONTINUE" = "y" ] || [ "$CONTINUE" = "Y" ]; then
		echo -n "Are you sure (** All DB Data will be Removed **) ?(Y/N) "
		read COMFIRM_YN
		if [ "$COMFIRM_YN" = "y" ] || [ "$COMFIRM_YN" = "Y" ]; then
			SKIP="Y"
			yum -y remove MariaDB-server
			rm -f -r /var/lib/mysql
			break
	fi
	elif [ "$CONTINUE" = "n" ] || [ "$CONTINUE" = "N" ]; then
		SKIP="N"
		break
	fi
done

systemctl stop firewalld
systemctl disable firewalld

echo
echo "DB Install start"
echo

PWD=`pwd`

rpm -ivh ../RPM/1/*.rpm --force --nodeps 2>/dev/null
rpm -ivh ../RPM/2/*.rpm --force --nodeps 2>/dev/null

systemctl start mariadb
systemctl stop firewalld
setenforce 0

cp -f CONFIG/config /etc/selinux/ 
cp -f CONFIG/rsyslog.conf /etc/rsyslog.conf
systemctl restart rsyslog

#tzdata DB Insert
echo "mysql tzdata Load..."
mysql mysql < PKGDATA/DB/mysql_timezone_data.sql

echo ""

# -------------------------------------------------------------------
# Anonymous Account Delete 
mysql -e "DELETE FROM mysql.user WHERE user='';"
# mysql@localhost ( UnixSocket Auth )
# 10.3.35는 unix_socket 지원하지 않음? 10.4 이후 사용 가능
mysql -e "CREATE OR REPLACE USER 'mysql'@'localhost' IDENTIFIED VIA unix_socket;"
mysql -e "GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT, SELECT, SHOW VIEW ON *.* TO 'mysql'@'localhost';"
# mariabackup@localhost ( UnixSocket Auth )
mysql -e "CREATE USER 'mariabackup'@'localhost' IDENTIFIED VIA unix_socket;"
mysql -e "GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'mariabackup'@'localhost';"
# root@localhost - Account Modify ( UnixSocket Auth + Password Auth )
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('skycom67960');"
# root@% - Account Creation ( Password Auth )
mysql -e "CREATE USER 'root'@'%' IDENTIFIED BY 'skycom67960';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"
# ipecscloud@localhost - Select Only Account Create ( Password Auth )
mysql -e "CREATE USER 'ipecscloud'@'localhost' IDENTIFIED BY 'IPECScm12#';"
mysql -e "GRANT PROCESS, SELECT ON *.* TO 'ipecscloud'@'localhost';"
# GRANT Reload 
mysql -e "FLUSH PRIVILEGES"
# -------------------------------------------------------------------

# sed: 텍스트 편집 도구, s: 대체, g: 전체 문서에서 모든 발생을 대체, [CLUSTER_ADDRESS] -> G_COMM
eval "cat CONFIG/server.cnf.2 | sed 's|\[CLUSTER_ADDRESS\]|$G_COMM|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[CLUSTER_NODE_ADDRESS\]|$NODE_ADDRESS|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[CLUSTER_NODE_NAME\]|$NODE_NAME|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[CLUSTER_NAME\]|$CLUSTER_NAME|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[OPTION_LOWER_CASE\]|$OPTION_lower_case_table_names|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[OPTION_INNODB_BUFFER_POOL\]|$OPTION_innodb_buffer_pool_size|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[OPTION_W_GCACHE_SIZE\]|$OPTION_W_GCACHE_SIZE|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf

eval "cat /etc/my.cnf.d/server.cnf | sed 's|\[OPTION_W_GCACHE_PAGE_SIZE\]|$OPTION_W_GCACHE_PAGE_SIZE|g' > ./server_ems_temp"
mv server_ems_temp /etc/my.cnf.d/server.cnf


mkdir -p /usr/local/skycom/bin 2>/dev/null
cp -r PKGDATA/BIN/bin/* /usr/local/skycom/bin
chmod 700 /usr/local/skycom/bin/*

mkdir -p /usr/local/skycom/var/config
cp -r CONFIG/elgcloud_db_enc_key.enc /usr/local/skycom/var/config
chown mysql:mysql /usr/local/skycom/var/config/elgcloud_db_enc_key.enc

mkdir -p /var/log/mariadb
chown mysql:mysql /var/log/mariadb

if [  "$SKIP" == "N" ]
then
	echo "127.0.0.1		`hostname`" >> /etc/hosts
fi

systemctl stop mariadb
pkill -9 mysqld

sleep 1

echo ""
echo "Cluster Status Check..."
v_CLUSTER_JOIN="N"
if [ -n "$NODE_ADDRESS" ] && [ "$G_COMM" != "$NODE_ADDRESS" ];then
	for cluster_node in ${G_COMM//,/ }; do
		echo "cluster_node:[$cluster_node]"
		if [ "$cluster_node" != "$NODE_ADDRESS" ];then
			v_CLUSTER_CHK="`mysql -u root -pskycom67960 -h $cluster_node -e"show status like 'wsrep_cluster_status'" -N | awk '{print $2}';`"
			echo "v_CLUSTER_CHK($cluster_node):[$v_CLUSTER_CHK]"
			if [ "$v_CLUSTER_CHK" = "Primary" ];then
				v_CLUSTER_JOIN="Y"
				break;
			fi
		fi
	done
	echo "v_CLUSTER_JOIN:[$v_CLUSTER_JOIN]"
	if [ "$v_CLUSTER_JOIN" = "Y" ];then
		echo "Join Mode - start  (* If the DB data size is Large, it may take a Long time *) ..."
		systemctl start mariadb		#service mysql start
	else
		echo "Master Mode (bootstrap) - start ..."
		galera_new_cluster			#service mysql bootstrap
	fi
else
	echo "Standalone Mode - New Cluster Mode - start ..."
	galera_new_cluster				#service mysql bootstrap 
fi

echo
echo -n "MariaDB Setting..."
echo ""
echo "MariaDB Setting OK"
echo ""

systemctl disable mariadb 		#chkconfig --level 123456 mysql off

## mysql - Open File Descriptor limit 추가
echo "" >> /etc/security/limits.conf
echo "# for mariabackup ( Add by maria_install.sh )" >> /etc/security/limits.conf
echo "mysql soft nofile 50000" >> /etc/security/limits.conf
echo "mysql hard nofile 50000" >> /etc/security/limits.conf
echo "" >> /etc/security/limits.conf
### Crontab추가 ( EMSDB Only )
if [ "$CRONTAB_DB_BACKUP" == "Y" ];then
	echo ""
	echo "Crontab Add (mariabackup_daily.sh)"
	echo "30 03 * * * /usr/local/skycom/bin/mariabackup_daily.sh" >> /var/spool/cron/root
	echo ""
fi
echo "=========================="
echo "MaraiDB Install end"
echo "=========================="
echo " "
echo "[Cluster Status Check] Command: /usr/local/skycom/bin/chkCluster.sh "
echo " " 

