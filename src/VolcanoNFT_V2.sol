// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "src/VolcanoCoin.sol";

contract VolcanoNFT_V2 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    VolcanoCoin public volcano;

    constructor() ERC721("VolcanoNFT", "VN") {
        volcano = new VolcanoCoin();
    }

    function mintNftWithETH() public payable returns (uint256) {
        require(msg.value == 0.0001 ether, "Need to pay 0.0001 ether");
        return mintIt();
    }

    function mintNftWithERC20() public payable returns (uint256) {
        require(
            volcano.transferFrom(msg.sender, address(this), 10 ether),
            "Need to pay 10 Volcano Coin"
        );
        return mintIt();
    }

    function mintIt() private returns (uint256) {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();
        _mint(msg.sender, newId);
        _setTokenURI(
            newId,
            "https://mokaiko.infura-ipfs.io/ipfs/QmQk3jAqJRjUDwKpb33weSLLEBVYJDjX1GYp6rNTTAkyLp"
        );
        return newId;
    }
}
