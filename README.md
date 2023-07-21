# MariaDB Install
+ **OS Version** 
	* Rocky-8.8-x86_64  
+ **Libraries**  
	* ipcalc-0.2.4-4.el8  
	* MariaDB-10.4.30-el8  
--------------------------------------------

# 1. maria.cfg 파일 수정
maria.cfg 설정 파일의 내용을 수정한다.

## Description
```
[COMMON]
GLOBAL_HIGH_AVAILABITY_YN=Y (지역적 이중화 유무 Y/N)
[PRIMARY]
PRIMARY_HIGH_AVAILABLITY_YN=Y (PRIMAY 지역의 로컬 이중화 유무 Y/N)
PRIMARY_MASTER_PRIVATE_IP=192.168.111.110 (PRIMARY Master 서버의 Private IP)
PRIMARY_SLAVE_PRIVATE_IP=192.168.111.111 (PRIMARY Slave 서버의 Private IP)
[SECONDARY]
SECONDARY_HIGH_AVAILABLITY_YN=N (SECONDARY 지역의 로컬 이중화 유무 Y/N)
SECONDARY_MASTER_PRIVATE_IP=192.168.111.120 (SECONDARY Master 서버의 Private IP)
SECONDARY_SLAVE_PRIVATE_IP=192.168.111.121 (SECONDARY Slave 서버의 Private IP)
```
--------------------------------------------

## 단일 서버 구성 예
```
[COMMON]
GLOBAL_HIGH_AVAILABITY_YN=N
[PRIMARY]
PRIMARY_HIGH_AVAILABLITY_YN=Y
PRIMARY_MASTER_PRIVATE_IP=192.168.111.110
PRIMARY_SLAVE_PRIVATE_IP=
[SECONDARY]
SECONDARY_HIGH_AVAILABLITY_YN=N
SECONDARY_MASTER_PRIVATE_IP=
SECONDARY_SLAVE_PRIVATE_IP=
```
--------------------------------------------

## 로컬 이중화 서버 구성 예
```
[COMMON]
GLOBAL_HIGH_AVAILABITY_YN=N
[PRIMARY]
PRIMARY_HIGH_AVAILABLITY_YN=Y
PRIMARY_MASTER_PRIVATE_IP=192.168.111.110
PRIMARY_SLAVE_PRIVATE_IP=192.168.111.111
[SECONDARY]
SECONDARY_HIGH_AVAILABLITY_YN=N
SECONDARY_MASTER_PRIVATE_IP=
SECONDARY_SLAVE_PRIVATE_IP=
```
--------------------------------------------

## 로컬 이중화, 지역 단일화 서버 구성 예
```
[COMMON]
GLOBAL_HIGH_AVAILABITY_YN=N
[PRIMARY]
PRIMARY_HIGH_AVAILABLITY_YN=Y
PRIMARY_MASTER_PRIVATE_IP=192.168.111.110
PRIMARY_SLAVE_PRIVATE_IP=192.168.111.111
[SECONDARY]
SECONDARY_HIGH_AVAILABLITY_YN=N
SECONDARY_MASTER_PRIVATE_IP=192.168.111.120
SECONDARY_SLAVE_PRIVATE_IP=
```
--------------------------------------------

# 2. 기본 설치
* Install 경로로 이동한다.
```
[root@localhost ~]# cd Install
```
+ 터미널에 아래의 명령어를 입력하여 설치 프로그램을 시작한다.
```
[root@localhost ~]# sh ./maria_install.sh
```
* maria_install.sh을 실행하면 설정 파일을 읽어서 화면에 보여준다.
```
PRIMARY_MASTER_PRIVATE_IP=[192.168.111.110]
SERVER_ROLE=[NONE]
CLUSTER_NAME=[192.168.111.110]
SKIP=[N]
... 생략
```

+ SERVER_ROLE은 현재 설치하는 서버가 어떤 서버인지 알려준다.
```
PA: PRIMARY_MASTER_IP가 이 서버의 IP인 경우
PS: PRIMARY_SLAVE_IP가 이 서버의 IP인 경우
SA: SECONDARY_MASTER_IP가 이 서버의 IP인 경우
SS: SECONDARY_SLAVE_IP가 이 서버의 IP인 경우
```

* G_COMM은 자신 의외의 동기화 해야 할 서버의 IP 정보를 ','로 구분해서 보여준다.
+ Would you like to reinstall? 
	* Y: 재설치로 진행되어 디렉토리 생성 및 RPM 설치를 생략하며 기존 DB가 모두 지워진다.
	* N: 처음 설치로 진행된다.
