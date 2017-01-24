#!/bin/bash
ESXPASSWD=""
#MOUNTNAME=$mountpoint
STORAGENAME=$STORAGENAME
STARTSEQ=$STARTSEQ
ENDSEQ=$ENDSEQ
user_req=$user_req
if [[ "$STARTSEQ" -gt "$ENDSEQ" ]]; then
	echo "Error Sequence" 
	exit 1
fi

function MOUNT () {
if [[ "$user_req" == "MOUNT" ]]
then
	local ESXSCRIPT="esxcli storage nfs add -H $STORAGENAME -s /$MOUNTNAME -v $DS_NAME"
	echo $ESXSCRIPT
else 
	local ESXSCRIPT="esxcli storage nfs remove --volume-name=$DS_NAME"
	echo $ESXSCRIPT
fi
}
mountpoint=`echo $mountpoint | tr ',' ' '`
for MOUNTNAME in $mountpoint; do 

DS_NAME=$MOUNTNAME

ESXSCRIPT=$(MOUNT)
echo $ESXSCRIPT
if [[ "$ENDSEQ" == "$STARTSEQ" || "$ENDSEQ" == "" ]];then
       SEQUENCE="$STARTSEQ"
else
        SEQUENCE=`seq $STARTSEQ $ENDSEQ `;
fi
	for i in $SEQUENCE;
	do
	expect -c "spawn ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@vmrack${i} $ESXSCRIPT; 
	set timeout 5; 
	expect -nocase -exact \"password: \"; 
	send -- \"$ESXPASSWD\r\"; 
	expect eof" ;
	done
done
##"set timeout -1;" with no timeout at all. 