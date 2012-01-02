ENV=prd
DEPLOYABLE=Future_Management.ear
PS1_PATH=/app/jboss-4.0.5.GA/server/$ENV-merch
/app/jboss-4.0.5.GA/server/prd-merch/deploy/Future_Management.ear
echo "######### Stopping MERCH #########"
shutMERCH
sleep 100
PS_COUNT=`ps -elf|grep java|grep MERCH|wc -l`
if [ $PS_COUNT -ne 0 ]; then echo "Jboss process still running, waiting for 30 secs."; sleep 30; fi
PS_COUNT=`ps -elf|grep java|grep MERCH|wc -l`
if [ $PS_COUNT -ne 0 ]; then echo "killing jboss process"; ps -elf|grep java|grep PS|cut -d" " -f4|xargs kill -9; fi
PS_COUNT=`ps -elf|grep java|grep MERCH|wc -l`
if [ $PS_COUNT -ne 0 ]; then echo "Could not stop jboss process, please stop it manually."; fi
echo "Please close all other jboss on other servers and press enter once done"
read temp_temp 
mv -v $PS1_PATH/farm/$DEPLOYABLE ~/${DEPLOYABLE}_`date +%d%m%Y`
cd $PS1_PATH/
rm -rf $PS1_PATH/tmp $PS1_PATH/data $PS1_PATH/work
rm -rf /data/ATG-Data/servers/PS1/logs
scp -p 10.0.101.19:/app/atgadmin/PackedEar_prod/$DEPLOYABLE $PS1_PATH/farm/
echo "######### Starting PS1 #########"
if [ $? -ne 0 ]; then echo "Could not copy file. Halting deploy."; fi
startPS1
