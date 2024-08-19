from ipfs_uploader import upload_to_ipfs
from contract_interactor import store_hash_in_contract

def main():
    file_path = 'example.png'  # Replace with your file path
    ipfs_hash = upload_to_ipfs(file_path)
    print(f"File uploaded to IPFS with hash: {ipfs_hash}")

    tx_hash = store_hash_in_contract(ipfs_hash)
    print(f"Transaction hash: {tx_hash}")

if __name__ == "__main__":
    main()
