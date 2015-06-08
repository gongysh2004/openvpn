# sudo pip install qingcloud-cli
# source ~/.bashrc
# mkdir ~/.qingcloud
#cat >~/.qingcloud/config.yaml <<EOF 
#qy_access_key_id: ''
#qy_secret_access_key: ''
#zone: 'ap1'
#EOF
vpnins_id='i-1j1cealo'
qingcloud iaas stop-instances -i $vpnins_id
