# IPFS Upload Smart Contract

This Solidity smart contract allows users to store IPFS hashes on the blockchain and retrieve file URLs using the IPFS gateway. The contract supports functionalities such as storing IPFS hashes, checking if a file exists, retrieving files by index, and more.

## Features

- **Ownership Control:** The contract uses an `Ownable` pattern, allowing only the owner to perform certain actions such as updating the IPFS gateway.
- **Reentrancy Protection:** The contract includes a `ReentrancyGuard` to protect against reentrant calls.
- **Store IPFS Hashes:** Users can store IPFS hashes, ensuring that duplicate hashes cannot be stored by the same user.
- **Retrieve Files:** Users can retrieve file URLs by providing the IPFS hash or by specifying an index in their file list.
- **Event Emissions:** Events are emitted for actions such as storing a hash, updating the gateway, and more.

## Contract Overview

### 1. **Ownable Contract**
   - Provides basic ownership functionality.
   - Functions:
     - `owner()`: Returns the current owner's address.
     - `transferOwnership(address newOwner)`: Transfers ownership to a new address.
     - `renounceOwnership()`: Renounces ownership, setting the owner to the zero address.

### 2. **ReentrancyGuard Contract**
   - Prevents reentrant calls to functions that use the `nonReentrant` modifier.

### 3. **IPFSUpload Contract**
   - Stores and retrieves IPFS hashes for users.
   - Functions:
     - **`setIPFSGateway(string memory newGateway)`**
       - Updates the IPFS gateway URL.
       - Only callable by the owner.
     - **`storeIPFSHash(string memory ipfsHash)`**
       - Stores a new IPFS hash for the user.
       - Emits `IPFSHashStored` and `TotalFileCountUpdated` events.
     - **`getTotalFileCount()`**
       - Returns the total number of files stored across all users.
     - **`fileExists(string memory ipfsHash)`**
       - Checks if a specific IPFS hash exists for the user.
     - **`getLatestFile()`**
       - Retrieves the last uploaded file URL for the caller.
     - **`getLatestUserFiles(address user)`**
       - Retrieves the last 100 file URLs uploaded by a specified user.
     - **`getTotalFiles(address user)`**
       - Returns the total number of files stored by a specified user.
     - **`getFileByIndex(address user, uint256 index)`**
       - Retrieves a specific file URL by index in the user's file list.
     - **`getFileByHash(address user, string memory ipfsHash)`**
       - Retrieves a file URL by directly providing the IPFS hash.

### Deployment

To deploy the contract, use a tool like Remix, Hardhat, or Truffle. Ensure you have the following:

- A configured Bitnet wallet.
- A connection to the Bitnet network (via a public or private RPC).

### Interacting with the Contract

1. **Set the IPFS Gateway** (Owner Only):
   ```solidity
   setIPFSGateway("https://gateway.example.com/ipfs/");
   ```
2. **Store an IPFS Hash**:
   ```solidity
   storeIPFSHash("QmExampleHash12345...");
   ```
3. **Check if a File Exists**:
   ```solidity
   bool exists = fileExists("QmExampleHash12345...");
   ```
4. **Retrieve the Last Uploaded File URL**:
   ```solidity
   string memory fileUrl = getLatestFile();
   ```
5. **Retrieve the Last 100 Files for a User**:
   ```solidity
   string[] memory files = getLatestUserFiles(userAddress);
   ```
6. **Retrieve a File URL by Index**:
   ```solidity
   string memory fileUrl = getFileByIndex(userAddress, index);
   ```
7. **Retrieve a File URL by Hash**:
   ```solidity
   string memory fileUrl = getFileByHash(userAddress, "QmExampleHash12345...");
   ```

### Events

- `IPFSHashStored(address indexed user, string indexed ipfsHash)`
  - Emitted when an IPFS hash is successfully stored.
- `GatewayUpdated(string newGateway)`
  - Emitted when the IPFS gateway is updated by the owner.
- `TotalFileCountUpdated(uint256 newTotalFileCount)`
  - Emitted when the total file count is updated.
- `FileExists(address indexed user, string indexed ipfsHash)`
  - Emitted when an attempt is made to store an IPFS hash that already exists.

### Security Considerations

- **Reentrancy Protection**: The contract is protected against reentrancy attacks using the ReentrancyGuard modifier.
- **Ownership**: Only the contract owner can change the IPFS gateway, ensuring centralized control over the gateway URL.





