use std::env;
use web3::contract::{Contract, Options};
use web3::transports::Http;
use web3::types::{Address, U256};
use dotenv::dotenv;

pub async fn store_hash_in_contract(ipfs_hash: &str) -> Result<String, Box<dyn std::error::Error>> {
    dotenv().ok();
    let rpc_url = env::var("RPC_URL")?;
    let private_key = env::var("PRIVATE_KEY")?;
    let contract_address = env::var("CONTRACT_ADDRESS")?;

    let transport = Http::new(&rpc_url)?;
    let web3 = web3::Web3::new(transport);
    
    let contract = Contract::from_json(
        web3.eth(),
        contract_address.parse::<Address>()?,
        include_bytes!("abi.json"),
    )?;

    let account = web3::signing::Key::from_hex(&private_key)?;
    let nonce = web3.eth().transaction_count(account.address(), None).await?;

    let tx = contract
        .call("storeIPFSHash", (ipfs_hash.to_string(),), account.address(), Options::default())
        .await?;

    Ok(format!("{:?}", tx))
}
