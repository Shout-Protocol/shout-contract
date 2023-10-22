source .env
export RPC_URL=$MUMBAI_RPC_URL
export EXPLORER_URL=$POLYGONSCAN_URL
export EXPLORER_API_KEY=$POLYGONSCAN_API_KEY

forge script script/deploy/DeployAll.s.sol --rpc-url $RPC_URL --verifier-url $EXPLORER_URL --etherscan-api-key $EXPLORER_API_KEY --broadcast --verify -vvvv --legacy