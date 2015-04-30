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
echo "Get eip of instance $vpninsid ..."
ret=`qingcloud iaas describe-instances -i $vpninsid`
check_retcode "$ret"
eip=`echo $ret | grep  -o -e 'eip-[a-z0-9]\+'`
echo "eip $eip"

echo 'Disociate eip $eip ...'
ret=`qingcloud iaas dissociate-eips -e $eip`
check_retcode "$ret"

echo 'Stop instance $vpninsid ...'
ret=`qingcloud iaas stop-instances -i $vpninsid`
check_retcode "$ret"

echo 'Release Eip $eip ...'
ret=`qingcloud iaas release-eips -F 1  -e $eip`
check_retcode "$ret"
