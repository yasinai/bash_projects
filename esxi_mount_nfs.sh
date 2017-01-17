#! /bin/bash
ESXPASSWD=""
MOUNTNAME=$MOUNTNAME
DS_NAME=$DS_NAME
STORAGENAME=$STORAGENAME
STARTSEQ=$STARTSEQ
ENDSEQ=$ENDSEQ
function MOUNT () {

local ESXSCRIPT='esxcli storage nfs add -H $STORAGENAME -s /$MOUNTNAME -v $DS_NAME'
echo $ESXSCRIPT
}

function UMOUNT () {

local ESXSCRIPT='esxcli storage nfs remove --volume-name=$DS_NAME'
echo $ESXSCRIPT
}

#remove storage "esxcli storage nfs remove --volume-name=scratch"
#add storage :  "esxcli storage nfs add -H fiona -s /scratch -v scratch"
#ESXSCRIPT="date"


$SEQUENCE=`seq $STARTSEQ $ENDSEQ `
for i in $SEQUENCE;
do
expect -c "spawn ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@vmrack${i} $ESXSCRIPT; 
set timeout 5; 
expect -nocase -exact \"password: \"; 
send -- \"$ESXPASSWD\r\"; 
expect eof" ;
done
##"set timeout -1;" with no timeout at all. 
#echo $ping
