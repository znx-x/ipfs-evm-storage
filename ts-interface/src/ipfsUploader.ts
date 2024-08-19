import axios from "axios";
import FormData from "form-data";
import * as dotenv from "dotenv";

dotenv.config();

const PINATA_API_KEY = process.env.PINATA_API_KEY!;
const PINATA_SECRET_API_KEY = process.env.PINATA_SECRET_API_KEY!;

export const uploadToIPFS = async (
  file: Buffer,
  fileName: string
): Promise<string> => {
  const url = `https://api.pinata.cloud/pinning/pinFileToIPFS`;

  const data = new FormData();
  data.append("file", file, {
    filename: fileName
  });

  const headers = {
    pinata_api_key: PINATA_API_KEY,
    pinata_secret_api_key: PINATA_SECRET_API_KEY,
    ...data.getHeaders()
  };

  try {
    const response = await axios.post(url, data, { headers });
    const ipfsHash = response.data.IpfsHash;
    return ipfsHash;
  } catch (error) {
    console.error("Error uploading file to IPFS:", error);
    throw error;
  }
};
