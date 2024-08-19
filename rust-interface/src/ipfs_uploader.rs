use reqwest::Client;
use std::env;
use std::fs::File;
use std::io::Read;
use dotenv::dotenv;
use serde::Deserialize;

#[derive(Deserialize)]
struct PinataResponse {
    IpfsHash: String,
}

pub async fn upload_to_ipfs(file_path: &str) -> Result<String, Box<dyn std::error::Error>> {
    dotenv().ok();
    let pinata_api_key = env::var("PINATA_API_KEY")?;
    let pinata_secret_api_key = env::var("PINATA_SECRET_API_KEY")?;
    
    let url = "https://api.pinata.cloud/pinning/pinFileToIPFS";
    let client = Client::new();

    let mut file = File::open(file_path)?;
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer)?;

    let form = reqwest::multipart::Form::new()
        .part("file", reqwest::multipart::Part::bytes(buffer).file_name(file_path.to_string()));

    let response = client
        .post(url)
        .multipart(form)
        .header("pinata_api_key", pinata_api_key)
        .header("pinata_secret_api_key", pinata_secret_api_key)
        .send()
        .await?;

    if response.status().is_success() {
        let pinata_response: PinataResponse = response.json().await?;
        Ok(pinata_response.IpfsHash)
    } else {
        Err(Box::from(format!("Failed to upload to IPFS: {}", response.text().await?)))
    }
}
