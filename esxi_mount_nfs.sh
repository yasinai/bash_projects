#! /bin/bash
ESXPASSWD=""
MOUNTNAME=$MOUNTNAME
DS_NAME=$DS_NAME
STORAGENAME=$STORAGENAME
STARTSEQ=$STARTSEQ
ENDSEQ=$ENDSEQ
user_req=$user_req
if [[ "$STARTSEQ" -gt "$ENDSEQ" ]]; then
	echo "Error Sequence" 
	exit 0
fi

function MOUNT () {
if [[ "$user_req" == "MOUNT" ]]
then
	local ESXSCRIPT='esxcli storage nfs add -H $STORAGENAME -s /$MOUNTNAME -v $DS_NAME'
	echo $ESXSCRIPT
else 
	local ESXSCRIPT='esxcli storage nfs remove --volume-name=$DS_NAME'
	echo $ESXSCRIPT
fi
}
ESXSCRIPT=$(MOUNT)
echo $ESXSCRIPT
if [[ "$ENDSEQ" == "$STARTSEQ" || "$ENDSEQ" == "" ]];then
       echo ${SEQUENCE:-$STARTSEQ};
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
##"set timeout -1;" with no timeout at all. 
