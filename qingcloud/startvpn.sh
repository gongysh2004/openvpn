vpninsid='i-rj8b03a6'
function echo_and_exit()
{
    echo $1
    if [[ "$1" != "0" ]]; then
        echo -e "\tFailed"
        exit 1
    fi
}
function check_retcode()
{
   echo  "$1"
   retcode=`echo $1 | grep  -o -e '"ret_code": [0-9]*' | awk '{print $2}'`
   echo  "return code $retcode"
   echo_and_exit $retcode
}
echo "Start instance $vpninsid ..."
ret=`qingcloud iaas start-instances -i $vpninsid`
check_retcode "$ret"

echo "Wait for instance $vpninsid to start ..."
ret=`qingcloud iaas describe-instances -i $vpninsid`
check_retcode "$ret"
status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
while :
do
   echo "$status"
   if [[ "$status" = "running" ]]; then
     echo "running checked!"
     break
   else
     echo -e ".\c"
     ret=`qingcloud iaas describe-instances -i $vpninsid`
     check_retcode "$ret"
     status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
   fi
done
echo 'Allocate eip ...'
ret=`qingcloud iaas allocate-eips -n test -b 4 -B bandwidth`
check_retcode "$ret"
eip=`echo -e $ret |  grep -e "eip-[^\"]*" -o`

echo "Associate eip $eip ..."
ret=`qingcloud iaas associate-eip -e $eip -i $vpninsid`
check_retcode "$ret"

echo "Checking eip $eip is associated..."
ret=`qingcloud iaas describe-eips -e $eip`
check_retcode "$ret"
status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
while :
do
   echo "$status"
   if [[ "$status" = "associated" ]]; then
     echo "associated checked!"
     break
   else
     echo -e ".\c"
     ret=`qingcloud iaas describe-eips -e $eip`
     check_retcode "$ret"
     status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
   fi
done

echo "Get EIP address $eip ..."
qingcloud iaas describe-instances -i $vpninsid | grep eip_addr | awk -F\" '{ print $4}'
