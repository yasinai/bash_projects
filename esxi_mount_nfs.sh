#! /bin/bash
ESXPASSWD=""
MOUNTNAME=$MOUNTNAME
DSNAME=$DSNAME
STORAGENAME=$STORAGENAME
STARTSEQ=$STARTSEQ
ENDSEQ=$ENDSEQ
function MOUNT {

ESXSCRIPT="esxcli storage nfs add -H $STORAGENAME -s /$MOUNTNAME -v $DSNAME"
}

function UMOUNT {

ESXSCRIPT="esxcli storage nfs remove --volume-name=$DSNAME"
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
