
#!/bin/bash
function ADD ()
{
local ESXSCRIPT='esxcli storage nfs add -H fiona -s /scratch -v scratch'
echo "$ESXSCRIPT"
}

function REM () 
{
local ESXSCRIPT='2nd function'
echo "$ESXSCRIPT"
}
funn="Hello"
result1=$(ADD)
result2=$(REM)
echo $result1
echo $result2
echo $funn
