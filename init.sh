apk add jq \
echo  $ACCOUNT_PASSWORD > /root/password.txt \
AD1=`geth account new --password /root/password.txt | grep "Public address of the key" | awk '{print substr($NF, 3)}'` \
AD2=`geth account new --password /root/password.txt | grep "Public address of the key" | awk '{print substr($NF, 3)}'`  \
cat /root/.ethereum/keystore/* \
    # Replace this with the new alloc field you want to set.
NEW_ALLOC='{"'${AD1}'": {"balance": "5000000000"}, "'${AD2}'": {"balance": "5000000000"}}' \
    # Update the alloc field'
jq --argjson newAlloc "$NEW_ALLOC" '.alloc = $newAlloc'  /tmp/genesis.json > /tmp/temp.json && mv /tmp/temp.json /tmp/genesis.json \
jq '.extradata = "0x0000000000000000000000000000000000000000000000000000000000000000'${AD1}'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"' /tmp/genesis.json > /tmp/temp.json && mv /tmp/temp.json /tmp/genesis.json \
geth init /tmp/genesis.json \
rm -f ~/.ethereum/geth/nodekey
