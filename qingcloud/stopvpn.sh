vpninsid='i-1j1cealo'
function echo_and_exit()
{
    echo -e "$1"
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
echo "Stop openvpn ..."
sudo systemctl stop openvpn@client
echo "Get eip of instance $vpninsid ..."
ret=`qingcloud iaas describe-instances -i $vpninsid`
check_retcode "$ret"
eip=`echo $ret | grep  -o -e 'eip-[a-z0-9]\+'`
echo "eip:${eip}-"
if [[ "y${eip}y" != "yy" ]]; then
    echo "Disociate eip $eip ..."
    ret=`qingcloud iaas dissociate-eips -e $eip`
    check_retcode "$ret"
    
    echo "Checking eip $eip is disociated..."
    ret=`qingcloud iaas describe-eips -e $eip`
    check_retcode "$ret"
    status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
    while :
    do
       echo "$status"
       if [[ "$status" = "available" ]]; then
         break
         echo "disociated checked!"
       else
         echo -e ".\c"
         ret=`qingcloud iaas describe-eips -e $eip`
         check_retcode "$ret"
         status=`echo -e "$ret" | grep -e '\"status\":' | awk -F\" '{ print $4}'`
       fi
    done
fi
echo "Stop instance $vpninsid ..."
ret=`qingcloud iaas stop-instances -i $vpninsid`
check_retcode "$ret"

if [[ "y${eip}y" != "yy" ]]; then
    echo "Release Eip $eip ..."
    ret=`qingcloud iaas release-eips -F 1  -e $eip`
    check_retcode "$ret"
fi
