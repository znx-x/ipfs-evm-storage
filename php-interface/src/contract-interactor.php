<?php

namespace Uploader;

use Web3\Web3;
use Web3\Contract;
use Web3\Providers\HttpProvider;
use Web3\RequestManagers\HttpRequestManager;
use Dotenv\Dotenv;

class ContractInteractor
{
    private $web3;
    private $contract;
    private $account;

    public function __construct()
    {
        $dotenv = Dotenv::createImmutable(__DIR__ . '/../');
        $dotenv->load();

        $rpcUrl = $_ENV['RPC_URL'];
        $contractAddress = $_ENV['CONTRACT_ADDRESS'];
        $privateKey = $_ENV['PRIVATE_KEY'];

        $provider = new HttpProvider(new HttpRequestManager($rpcUrl, 10));
        $this->web3 = new Web3($provider);
        $this->account = $this->web3->eth->account->privateKeyToAccount($privateKey);

        // Load the ABI from a file or use a hardcoded ABI
        $abi = file_get_contents(__DIR__ . '/abi.json');
        $this->contract = new Contract($provider, $abi);
        $this->contract->at($contractAddress);
    }

    public function storeHashInContract(string $ipfsHash): string
    {
        $nonce = $this->web3->eth->getTransactionCount($this->account->getAddress(), 'latest');

        $transaction = $this->contract->send('storeIPFSHash', $ipfsHash, [
            'from' => $this->account->getAddress(),
            'nonce' => $nonce,
            'gas' => '2000000',
            'gasPrice' => '5000000000', // 5 Gwei
        ], $this->account->getPrivateKey());

        return $transaction->getTransactionHash();
    }
}
