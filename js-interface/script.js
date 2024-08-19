document.getElementById('uploadForm').addEventListener('submit', async function(event) {
    event.preventDefault();
    const file = document.getElementById('fileInput').files[0];
    
    if (!file) {
        alert('Please select a file to upload.');
        return;
    }

    try {
        const ipfsHash = await uploadToIPFS(file);
        document.getElementById('output').innerText = `IPFS Hash: ${ipfsHash}`;
        const txHash = await storeHashInContract(ipfsHash);
        document.getElementById('output').innerText += `\nTransaction Hash: ${txHash}`;
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('output').innerText = `Error: ${error.message}`;
    }
});

async function uploadToIPFS(file) {
    const pinataApiKey = 'your_pinata_api_key'; // ADD YOUR OWN PINATA API KEY HERE
    const pinataSecretApiKey = 'your_pinata_secret_api_key'; // ADD YOUR OWN PINATA SECRET API KEY HERE
    const url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
    
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(url, {
        method: 'POST',
        headers: {
            'pinata_api_key': pinataApiKey,
            'pinata_secret_api_key': pinataSecretApiKey,
        },
        body: formData
    });

    if (!response.ok) {
        throw new Error(`Failed to upload to IPFS: ${response.statusText}`);
    }

    const data = await response.json();
    return data.IpfsHash;
}

async function storeHashInContract(ipfsHash) {
    const rpcUrl = 'your_custom_rpc_url'; // ADD YOUR OWN CUSTOM RPC URL HERE
    const privateKey = 'your_private_key'; // ADD YOUR OWN WALLET PRIVATE KEY HERE
    const contractAddress = 'your_bitnet_contract_address';
    const abi = await fetch('abi.json').then(response => response.json());

    const web3 = new Web3(new Web3.providers.HttpProvider(rpcUrl));
    const account = web3.eth.accounts.privateKeyToAccount(privateKey);
    web3.eth.accounts.wallet.add(account);
    web3.eth.defaultAccount = account.address;

    const contract = new web3.eth.Contract(abi, contractAddress);
    
    const tx = contract.methods.storeIPFSHash(ipfsHash);
    const gas = await tx.estimateGas({ from: account.address });
    const gasPrice = await web3.eth.getGasPrice();

    const signedTx = await web3.eth.accounts.signTransaction({
        to: contractAddress,
        data: tx.encodeABI(),
        gas,
        gasPrice
    }, privateKey);

    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    return receipt.transactionHash;
}
