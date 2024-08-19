# IPFS Storage for Bitnet

## Overview

This repository provides a solution for integrating IPFS-based file storage with the Bitnet network. It enables indirect IPFS file storage and direct hash indexing on Bitnet, making it possible to leverage decentralized and immutable storage for a variety of applications.

## Use Cases

The IPFS Storage protocol serves as a bridge between the Bitnet network and IPFS, allowing for permanent and immutable file storage. It can be utilized for:

- Hosting permanent records for applications in accounting, logistics, healthcare, and more.
- Persistent storage of physical contracts, titles, and other legal documents.
- Immutable storage of photos, videos, and other media.
- General decentralized hosting for various types of files.

## Protocol Mechanics

**IPFS Service Utilized:** Piñata Cloud (can be updated to use any other compatible service).

### Step 1: Uploading

- The user uploads a file to IPFS via the interface.

### Step 2: Hash Collection

- If the file is uploaded successfully, the interface collects the IPFS file hash and calls the `storeIPFSHash` function on the smart contract.

### Step 3: Storing

- The smart contract stores the IPFS hash along with relevant metadata.

### Step 4: Accessing

- The user can call the smart contract using one of the available functions, such as `getFileByHash`, to retrieve the specific file URL. The contract returns the concatenated URL using the stored IPFS Gateway URL.

## Smart Contract

The smart contract is designed to store and index IPFS file hashes. It allows for retrieving file links either by using IPFS hashes or by referencing the index position within the stored hashes.

## Interface

Developers can either build an interface from scratch or use one of the provided templates to build upon. Templates are available in **TypeScript**, **JavaScript/HTML**, **Python**, **PHP**, and **Rust**. Most languages with Web 3 support are compatible with this protocol.

