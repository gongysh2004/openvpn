# sudo pip install qingcloud-cli
# source ~/.bashrc
# mkdir ~/.qingcloud
#cat >~/.qingcloud/config.yaml <<EOF 
#qy_access_key_id: ''
#qy_secret_access_key: ''
#zone: 'ap1'
#EOF
vpnins_id='i-rj8b03a6'
qingcloud iaas stop-instances -i $vpnins_id
