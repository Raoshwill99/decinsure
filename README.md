# Decentralized Insurance Mechanism for Smart Contract Failures

## Overview

This project implements a decentralized insurance protocol on the Stacks blockchain using Clarity. The protocol aims to automatically compensate users if a smart contract experiences a failure or security breach. The insurance is funded through a decentralized pool of contributors, adding a new layer of trust and security for users in the blockchain ecosystem.

## Features

- [x] Decentralized insurance pool
- [x] User contributions to the pool
- [x] Registration of insured contracts with coverage amounts
- [x] Claim filing system
- [x] Claim approval and rejection mechanism
- [x] Automatic payout for approved claims
- [ ] Decentralized governance for decision-making
- [ ] Risk-based premium calculation
- [ ] Abuse prevention mechanisms

## Smart Contract Structure

The main contract (`insurance-mechanism.clar`) contains the following key components:

1. **Constants**: Defines the contract owner and error codes.
2. **Data Variables**: Tracks the total insurance pool balance.
3. **Maps**: 
   - `contributors`: Records individual contributions.
   - `insured-contracts`: Tracks which contracts are insured and their coverage amounts.
   - `claims`: Stores information about filed claims.
4. **Public Functions**:
   - `contribute`: Allows users to add funds to the insurance pool.
   - `register-contract`: Enables the contract owner to register insured contracts with coverage amounts.
   - `file-claim`: Allows users to file claims against insured contracts.
   - `approve-claim`: Allows the contract owner to approve and process claims.
   - `reject-claim`: Allows the contract owner to reject claims.
5. **Read-only Functions**:
   - `get-pool-balance`: Returns the current insurance pool balance.
   - `is-contract-insured`: Checks if a given contract is insured.
   - `get-contribution`: Retrieves the contribution amount for a given user.
   - `get-claim-status`: Retrieves the status of a specific claim.
   - `get-contract-coverage`: Returns the coverage amount for a given contract.

## Setup and Deployment

To deploy this contract:

1. Ensure you have the Stacks CLI installed and configured.
2. Clone this repository.
3. Navigate to the project directory.
4. Deploy the contract using the Stacks CLI:

   ```
   stacks deploy insurance-mechanism.clar
   ```

## Usage

After deployment, users can interact with the contract through the provided public functions:

- To contribute to the insurance pool:
  ```
  stacks call contribute
  ```

- To file a claim (replace `<contract-address>` and `<amount>` with actual values):
  ```
  stacks call file-claim <contract-address> <amount>
  ```

- To check the status of a claim (replace `<contract-address>` with the actual address):
  ```
  stacks call get-claim-status <contract-address> tx-sender
  ```

Note: Only the contract owner can register insured contracts, and approve or reject claims.

## Future Development

This project is under active development. Upcoming features include:

1. Implementing a decentralized governance system for decision-making.
2. Developing a risk-based premium calculation system.
3. Implementing mechanisms to prevent abuse and ensure fairness.
4. Adding more sophisticated claim validation mechanisms.
5. Integrating with external oracles for automated claim verification.

## Contributing

Contributions to this project are welcome. Please ensure you follow the coding standards and submit pull requests for any new features or bug fixes.

## License

[MIT License](LICENSE)

## Contact

For any queries regarding this project, please open an issue in the GitHub repository.
