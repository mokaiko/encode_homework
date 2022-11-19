// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "src/VolcanoCoin.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "forge-std/StdUtils.sol";

/// @title Mint NFT, store the NFT Metadata on chain
/// @author Mo Kaiko
/// @notice Use ETH or ERC20 tokens to pay for minting NFT

contract VolcanoNFT_V3 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // <svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 400 400'><rect width='100%' height='100%' fill='lightblue' /><circle cx='120' cy='80' r='40' fill='red' /><polygon points='160,160 170,165 185,162 192,172 209,168 219,173 240,165 320,400 100,400' fill='grey' /></svg>
    string baseSvg1_SkyColor =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 400 400'><rect width='100%' height='100%' fill='";
    string baseSvg2_SunColor = "' /><circle cx='120' cy='80' r='40' fill='";
    string baseSvg3_VolcanoColor =
        "' /><polygon points='160,160 170,165 185,162 192,172 209,168 219,173 240,165 320,400 100,400' fill='";
    string baseSvg4_end = "' /></svg>";

    string[] skyColors = [
        "blue",
        "lightblue",
        "grey",
        "white",
        "black",
        "cyan"
    ];
    string[] sunColors = ["red", "orange", "yellow", "plum", "magenta"];

    string[] volcanoColors = [
        "lightgrey",
        "silver",
        "green",
        "lightgreen",
        "purple",
        "violet"
    ];

    VolcanoCoin public volcano;

    constructor() ERC721("VolcanoNFT", "VN") {
        volcano = new VolcanoCoin();
    }

    function pickRandomSkyColor(uint256 tokenId)
        private
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SKY_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % skyColors.length;
        return skyColors[rand];
    }

    function pickRandomSunColor(uint256 tokenId)
        private
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SUN_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % sunColors.length;
        return sunColors[rand];
    }

    function pickRandomVolcanoColor(uint256 tokenId)
        private
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("VOLCANO_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % volcanoColors.length;
        return volcanoColors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
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

        string memory skyColor = pickRandomSkyColor(newId);
        string memory sunColor = pickRandomSunColor(newId);
        string memory volcanoColor = pickRandomVolcanoColor(newId);

        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg1_SkyColor,
                skyColor,
                baseSvg2_SunColor,
                sunColor,
                baseSvg3_VolcanoColor,
                volcanoColor,
                baseSvg4_end
            )
        );
        console2.log("final SVG:", finalSvg);
        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Volcano NFT # ',
                        Strings.toString(newId),
                        '", "description": "A collection of beautiful volcanoes.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console2.log("final token URL:", finalTokenUri);

        _mint(msg.sender, newId);
        _setTokenURI(newId, finalTokenUri);
        return newId;
    }
}
