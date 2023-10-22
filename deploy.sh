source .env
export RPC_URL=$FILECOIN_CALIBRATION_RPC_URL
export EXPLORER_URL=$FILECOIN_CALIBRATION_SCAN_URL
export EXPLORER_API_KEY=$FILECOIN_CALIBRATION_SCAN_API_KEY

# forge script script/deploy/DeployAll.s.sol --rpc-url $RPC_URL --verifier-url $EXPLORER_URL --etherscan-api-key $EXPLORER_API_KEY --broadcast --verify
forge script script/deploy/DeployTestERC20.s.sol --rpc-url $RPC_URL  --broadcast