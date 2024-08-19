<?php

namespace Uploader;

use GuzzleHttp\Client;
use Dotenv\Dotenv;

class IpfsUploader
{
    private $pinataApiKey;
    private $pinataSecretApiKey;

    public function __construct()
    {
        $dotenv = Dotenv::createImmutable(__DIR__ . '/../');
        $dotenv->load();

        $this->pinataApiKey = $_ENV['PINATA_API_KEY'];
        $this->pinataSecretApiKey = $_ENV['PINATA_SECRET_API_KEY'];
    }

    public function uploadToIpfs(string $filePath): string
    {
        $client = new Client();
        $url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

        $response = $client->post($url, [
            'headers' => [
                'pinata_api_key' => $this->pinataApiKey,
                'pinata_secret_api_key' => $this->pinataSecretApiKey,
            ],
            'multipart' => [
                [
                    'name' => 'file',
                    'contents' => fopen($filePath, 'r'),
                    'filename' => basename($filePath),
                ],
            ],
        ]);

        $body = json_decode($response->getBody(), true);

        if (isset($body['IpfsHash'])) {
            return $body['IpfsHash'];
        }

        throw new \Exception('Failed to upload file to IPFS: ' . $response->getBody());
    }
}
