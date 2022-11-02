[Foundry]
    code: 
    contract: https://goerli.etherscan.io/tx/0xff966468dc9f8a2cfb7b3f4af6416cd4066bd2bc063370bc20a0f4b759096227

    $ forge create --rpc-url <YOUR RPC URL> --private-key <YOUR PK> src/VolcanoNFT.sol:VolcanoNFT

    $ cast send --private-key <YOUR PK> 0xC73436FEbE48bEda1808Dc600F86666A107CB866 "mintMyNFT()(uint256)" --rpc-url <YOUR RPC URL>

[Hardhat]
    code: https://github.com/mokaiko/encode_homework/tree/volcanonft_hardhat_ts
    contract: https://goerli.etherscan.io/address/0xf465ed1069b3aaf6cea2014fcb93da64a01ce58d