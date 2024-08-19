<?php

require __DIR__ . '/../vendor/autoload.php';

use Uploader\IpfsUploader;
use Uploader\ContractInteractor;

$uploader = new IpfsUploader();
$interactor = new ContractInteractor();

try {
    $filePath = 'example.png'; // Replace with your file path
    $ipfsHash = $uploader->uploadToIpfs($filePath);
    echo "File uploaded to IPFS with hash: $ipfsHash\n";

    $txHash = $interactor->storeHashInContract($ipfsHash);
    echo "Transaction hash: $txHash\n";
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
