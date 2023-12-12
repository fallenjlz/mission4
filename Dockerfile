# Pull Docker image of official golang ethereum implementation 
FROM ethereum/client-go:stable
# install json tools
# Genesis file defined genesis block.
COPY genesis.json /tmp 

# Generate a new account (to pre-fund) using "password123" password
ARG ACCOUNT_PASSWORD=password123


RUN apk add jq \
    && echo  $ACCOUNT_PASSWORD > /root/password.txt \
    && AD1=`geth account new --password /root/password.txt | grep "Public address of the key" | awk '{print substr($NF, 3)}'` \
    && AD2=`geth account new --password /root/password.txt | grep "Public address of the key" | awk '{print substr($NF, 3)}'`  \
    && export AD1 \
    && cat /root/.ethereum/keystore/* \
    # Replace this with the new alloc field you want to set.
    && NEW_ALLOC='{"'${AD1}'": {"balance": "500000000"}, "'${AD2}'": {"balance": "5000000000"}}' \
    # Update the alloc field'
    && jq --argjson newAlloc "$NEW_ALLOC" '.alloc = $newAlloc'  /tmp/genesis.json > /tmp/temp.json && mv /tmp/temp.json /tmp/genesis.json \
    && jq '.extradata = "0x0000000000000000000000000000000000000000000000000000000000000000'${AD1}'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"' /tmp/genesis.json > /tmp/temp.json && mv /tmp/temp.json /tmp/genesis.json \
#     && cat /tmp/genesis.json \
#     # Initializing geth
    && geth init /tmp/genesis.json \
    && rm -f ~/.ethereum/geth/nodekey



# Generate a new account (to use for miner) using "password123" password
# RUN geth account new --password /root/password.txt \
#     && cat /root/.ethereum/keystore/*

ENTRYPOINT ["geth"]
