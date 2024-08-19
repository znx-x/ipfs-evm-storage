// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Adds basic ownership functionality to the smart contract
contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// Reentrancy Guard
contract ReentrancyGuard {
    bool private _locked;

    modifier nonReentrant() {
        require(!_locked, "ReentrancyGuard: reentrant call");
        _locked = true;
        _;
        _locked = false;
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

contract IPFSUpload is Ownable, ReentrancyGuard {
    using Strings for uint256;

    event IPFSHashStored(address indexed user, string indexed ipfsHash);
    event GatewayUpdated(string newGateway);
    event FileExists(address indexed user, string indexed ipfsHash);
    event TotalFileCountUpdated(uint256 newTotalFileCount);

    string public ipfsGateway = "https://gateway.example.com/ipfs/";
    uint256 private totalFileCount;

    mapping(address => string[]) private userFiles;
    mapping(address => mapping(string => bool)) private fileExistsMap;

    // Function to update the IPFS Gateway address
    function setIPFSGateway(string memory newGateway) external onlyOwner {
        ipfsGateway = newGateway;
        emit GatewayUpdated(newGateway);
    }

    // Function to store an IPFS hash
    function storeIPFSHash(string memory ipfsHash) external nonReentrant {
        require(
            !fileExistsMap[msg.sender][ipfsHash],
            "File already exists on IPFS"
        );

        // Store the new file hash
        userFiles[msg.sender].push(ipfsHash);
        fileExistsMap[msg.sender][ipfsHash] = true;

        // Increment the total file count
        totalFileCount++;
        emit IPFSHashStored(msg.sender, ipfsHash);
        emit TotalFileCountUpdated(totalFileCount);
    }

    // Function to get the total number of files uploaded
    function getTotalFileCount() external view returns (uint256) {
        return totalFileCount;
    }

    // Function to check if a file hash already exists
    function fileExists(string memory ipfsHash) external view returns (bool) {
        return fileExistsMap[msg.sender][ipfsHash];
    }

    // Function to retrieve the last uploaded file
    function getLatestFile() external view returns (string memory) {
        require(userFiles[msg.sender].length > 0, "No files stored");
        return
            string(
                abi.encodePacked(
                    ipfsGateway,
                    userFiles[msg.sender][userFiles[msg.sender].length - 1]
                )
            );
    }

    // Function to retrieve the last 100 stored IPFS file links for a user
    function getLatestUserFiles(
        address user
    ) external view returns (string[] memory) {
        uint256 totalFiles = userFiles[user].length;
        uint256 start = totalFiles > 100 ? totalFiles - 100 : 0;
        uint256 count = totalFiles - start;

        string[] memory fileLinks = new string[](count);

        for (uint i = 0; i < count; i++) {
            fileLinks[i] = string(
                abi.encodePacked(ipfsGateway, userFiles[user][start + i])
            );
        }

        return fileLinks;
    }

    // Function to return the total number of files stored by a user
    function getTotalFiles(address user) external view returns (uint256) {
        return userFiles[user].length;
    }

    // Function to retrieve a specific file link by index
    function getFileByIndex(
        address user,
        uint256 index
    ) external view returns (string memory) {
        require(index < userFiles[user].length, "Invalid index");
        return string(abi.encodePacked(ipfsGateway, userFiles[user][index]));
    }

    // Function to retrieve a file link by IPFS hash
    function getFileByHash(
        address user,
        string memory ipfsHash
    ) external view returns (string memory) {
        require(fileExistsMap[user][ipfsHash], "File not found");

        // Return the full IPFS URL for the hash
        return string(abi.encodePacked(ipfsGateway, ipfsHash));
    }
}
