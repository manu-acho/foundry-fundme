-include test/.env # include environment variables
build:
	forge build

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --fork-url $(SEPOLIA_RPC_URL) 
	--private-key $(PRIVATE_KEY_SEP) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv