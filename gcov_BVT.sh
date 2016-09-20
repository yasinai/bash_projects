#!/bin/bash
$Release_Version=$1
rm -rf /prod/gcov/$Release_Version/lcov /prod/gcov/$Release_Version/genhtml
mkdir -p /prod/gcov/$Release_Version/lcov
mkdir -p /prod/gcov/$Release_Version/genhtml
#for job in GCOV_stream_Kaveret-ClusterControl GCOV_stream_Kaveret-ClusterSetup GCOV_stream_Kaveret-CoreFilesystem GCOV_stream_Kaveret-NasFilesystem
for job in GCOV_stream_Kaveret-NasFilesystem #Temp changes for checkns stream (last stat in line above)
do
  for i in 0 1
  do
         #Clean *gcda from the previous run
         ct setview -exec find /vobs -name "*.gcda" | xargs -n 100 rm -f  
         #Copy .gcda to view 
         ct setview -exec   if [[ -d /prod/gcov/$Release_Version/$job.$i/vobs ]]; then cp -r -v /prod/gcov/$Release_Version/$job.$i/vobs/* /vobs/; fi  
         #data_reduction
         ct setview -exec   if [[ -d /vobs/fs/data_reduction ]]; then cd /vobs/fs/data_reduction &&  lcov -d . -b /vobs/fs/data_reduction/src/osd --capture --output-file /prod/gcov/$Release_Version/lcov/$job.${i}.fs.data_reduction.info --no-external -f; fi  
         #fs
         ct setview -exec   if [[ -d /vobs/fs/x86_64 ]]; then cd /vobs/fs/x86_64 &&  lcov -d . -b /vobs/fs/src --capture --output-file /prod/gcov/$Release_Version/lcov/$job.${i}.fs.info --no-external -f; fi   
         #cluster mng platform proto
         for component in cluster mng platform 
         do
           ct setview -exec   if [[ -d /vobs/build/build-root/x86_64-release/${component} ]]; then  cd /vobs/build/build-root/x86_64-release/${component} && lcov -d . -b /vobs/${component} --capture --output-file /prod/gcov/$Release_Version/lcov/$job.${i}.${component}.info --no-external; fi    
         done
         #Likewise
         #Delete problematic GCOV data files for auto-generated stub files
         #igorz ct setview -exec 'find /vobs/vendor/likewise-cifs/x86_64-debug \( -name "*_sstub.*.gcda" -o -name "*_cstub.*.gcda" \) -exec rm {} \;' 
         
         #Walk through the components
         for component in dcerpc dell libuuid lsass lwadvapi lwbase lwio lwmsg lwreg lwsm lwstats netlogon srvsvc
         do
             ct setview -exec  if [[ -d /vobs/vendor/likewise-cifs/x86_64-release/object/${component} ]]; then cd /vobs/vendor/likewise-cifs/x86_64-release/object/${component} && lcov -d . -b /vobs/vendor/likewise-cifs/${component} --capture --output-file /prod/gcov/$Release_Version/lcov/$job.${i}.vendor.lw.${component}.info --no-external; fi    
         done
         #NDMP correct path
         ct setview -exec  if [[ -d /vobs/proto/ndmp/x86_64 ]]; then cd /vobs/proto/ndmp/x86_64 && lcov -d . -b /vobs/proto/ndmp/src/dell --capture --output-file /prod/gcov/$Release_Version/lcov/${stream}.${i}.proto.info --ignore-errors gcov,source,graph --no-external; fi   
   done
done
#Remove empty .info files
find /prod/gcov/$Release_Version/lcov/ -type f -size 0 | xargs rm -f

ct setview -exec   genhtml /prod/gcov/$Release_Version/lcov/*.info --o /prod/gcov/$Release_Version/genhtml --ignore-errors source --prefix /vobs  
ct setview -exec   ct unco -rm /vobs/platform/itf/auto_framework/common_tasks/InstallTasks.py  
