#!/bin/bash
#echo "Top  heavy ClearCase view users:"
#/ccase/bin/heavy_users_cc
dirs="/ccview_cc2 /ccview_cc2n"
#dirs="/var /tmp"
recipient_list=$(
for dir in ${dirs};
        do cd ${dir} && du -ks * 2>/dev/null | grep [0-9] |  sort -k1 -n ; done |
   awk ' {v[$2]+=$1} END {for (i in v) if (v[i] > "$SIZE" ) print i, v[i] } ' |
while read user size ; do
    name=`ypmatch "$user" passwd | awk -F\: '{print $5}' | sed -e "s/ /_/g" | tr '[:upper:]' '[:lower:]' `
    [ -z "$name" ] && error "failed to get ${user}'s name from nis"
    recipient=""$name"@$company"
    #echo "${recipient}," >> /tmp/recipient_list
    echo $recipient
done
)
#recipient_list=$(echo $recipient_list | sed -e "s/ /,/g")     #Email plugin have get format with commas
echo "our list is $recipient_list"
echo "recipient_list=`echo $recipient_list`" > env.properties  #Export to Enj. Env plugin to $WORKSPACE of Jenkins from wee can use it.
#recipient_list=`cat /tmp/recipient_list | tr '/n' ' '`
#echo "recipient_list=`cat /tmp/recipient_list`"