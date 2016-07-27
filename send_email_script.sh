#!/bin/bash
echo "Email to custom size  ClearCase view users:"
# SIZE variable taken from Jenkins environment. 
#dirs="/ccview_cc2 /ccview_cc2n"
company="dell.com"
SIZE=10000
dirs="/var /tmp"
for dir in ${dirs};
        do cd ${dir} && du -ks * 2>/dev/null | grep [0-9] | egrep 'sinai|igor' |  sort -k1 -n ; done |
   awk ' {v[$2]+=$1} END {for (i in v) if (v[i] > "$SIZE" ) print i, v[i] } ' |
while read user size ; do
    name=`ypmatch "$user" passwd | awk -F\: '{print $5}' | sed -e "s/ /_/g" | tr '[:upper:]' '[:lower:]' `
    [ -z "$name" ] && error "failed to get ${user}'s name from nis"
    echo  ""$name"@$company"
done                              