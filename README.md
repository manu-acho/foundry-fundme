## FundMe Smart Contract

## Overview

This FundMe contract is a crowd funding application that allows users to contribute funds (ETH) and tracks each contributor's total contributions. The contract converts the contributed ETH to its equivalent USD value using Chainlink's AggregatorV3Interface to ensure accurate and secure price feeds.

## Features

- **Chainlink Price Feeds**: Leverages Chainlink price feeds to convert ETH contributions to their USD equivalent.
- **Secure Funding Mechanism**: Utilizes mappings to track individual contributions.
- **Withdrawal Functionality**: Allows the contract owner to withdraw accumulated funds.
- **Owner Privileges**: Restricts sensitive actions, such as withdrawals, to the owner of the contract.
- **Fallback and Receive Functions**: Accepts direct ETH transfers by triggering the fund function.

## Smart Contracts Overview

The following smart contracts are part of this package:

- **FundMe**: Allows users to fund with ETH, which is automatically converted to its USD equivalent. It includes functions for funding, withdrawing, and querying contributions.

- **DeployFundMe**: Script to deploy the FundMe contract with settings appropriate for the active network.

- **FundFundMe**: Script that facilitates funding the FundMe contract by sending ETH directly.

- **WithdrawFundMe**: Script for withdrawing all funds from the FundMe contract, ensuring that only the contract owner can perform withdrawals.

- **InteractionsTest**: Contains tests for the FundMe contract to ensure all interactions such as funding and withdrawing function as expected.

- **HelperConfig**: Provides network configuration settings for the FundMe deployment, ensuring correct setup across different environments.

- **CreateSubscription**: Script for creating a subscription for the Chainlink VRF in a testing or development environment.

- **FundSubscription**: Facilitates funding a Chainlink VRF subscription, crucial for enabling randomness in contract operations.

- **AddConsumer**: Adds a consumer to a Chainlink VRF subscription, allowing the FundMe contract to request randomness.

Each contract serves a specific function, from deployment, testing, to operational utilities, ensuring comprehensive coverage and functionality.


## Prerequisites

To interact with the FundMe contract or deploy it yourself, you'll need:
- [Node.js](https://nodejs.org/)
- [Foundry](https://book.getfoundry.sh/getting-started/installation.html) for smart contract development and testing
- An Ethereum wallet like [Metamask](https://metamask.io/)

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/fundme-contract.git
   cd fundme-contract
   ```
2. **Install Dependencies**

Assuming Foundry is installed globally, run:
```bash
forge install
```
3. **Compile Contracts**
```bash
forge build
```

## Configuration
Update the HelperConfig script with your specific network configurations, including the appropriate price feed address based on your deployment network.

## Deployment
Use Foundry to deploy the contracts: - See Makefile
```bash
forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)
```
## Usage

- **Funding**: Send ETH to the contract with a value exceeding the minimum USD threshold.
- **Withdraw Funds**: If you are the owner, withdraw funds collected by the contract.
- **Query Contributions**: Check how much you or another address has contributed in USD.

## Contract Methods

- `fund()`: Contribute ETH to the fund. Converts the ETH to its USD equivalent.
- `withdraw()`: Withdraw all funds from the contract (restricted to the owner).
- `cheaperWithdraw()`: A gas-optimized version of the `withdraw()` function.
- `getVersion()`: Returns the version of the Chainlink price feed.
- `getOwner()`: Returns the address of the contract owner.

## Running Tests

To ensure the functionality of the FundMe contract, run the provided tests:
```bash
forge test
```
## Contributing

Contributions are welcome. Please fork the repository and submit pull requests with any updates.

## Security

Ensure to review and test the contract thoroughly before deploying it on the mainnet. It is recommended to perform audits to identify potential security vulnerabilities.
