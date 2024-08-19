import fs from "fs";
import { uploadToIPFS } from "./ipfsUploader";
import { storeHashInContract } from "./contractInteractor";

const fileName = "example.png"; // Replace with any file path
const file = fs.readFileSync(fileName);

async function main() {
  try {
    // Upload to IPFS
    const ipfsHash = await uploadToIPFS(file, fileName);
    console.log(`File uploaded to IPFS with hash: ${ipfsHash}`);

    // Store IPFS hash in the Bitnet smart contract
    await storeHashInContract(ipfsHash);
  } catch (error) {
    console.error("Error in the main process:", error);
  }
}

main();
