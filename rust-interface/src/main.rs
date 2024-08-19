mod ipfs_uploader;
mod contract_interactor;

#[tokio::main]
async fn main() {
    let file_path = "example.png"; // Replace with your file path
    
    match ipfs_uploader::upload_to_ipfs(file_path).await {
        Ok(ipfs_hash) => {
            println!("File uploaded to IPFS with hash: {}", ipfs_hash);

            match contract_interactor::store_hash_in_contract(&ipfs_hash).await {
                Ok(tx_hash) => println!("Transaction hash: {}", tx_hash),
                Err(e) => eprintln!("Error storing hash in contract: {}", e),
            }
        }
        Err(e) => eprintln!("Error uploading file to IPFS: {}", e),
    }
}
