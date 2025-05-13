// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC1155Token is ERC1155, Ownable {
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant BRONZE = 2;

    string private baseURI;

    constructor()
        ERC1155("") // Unused; we override uri()
        Ownable(msg.sender)
    {
        baseURI = "https://raw.githubusercontent.com/samkoh-gambit/simple-erc1155/main/metadata/{id}.json";
    }

    function setURI(string memory newuri) public onlyOwner {
        baseURI = newuri;
    }

    function uri(uint256 id) public view override returns (string memory) {
        return _replaceIdPlaceholder(baseURI, id);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount
    ) public onlyOwner {
        _mint(account, id, amount, "");
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, "");
    }

    // Internal Helpers

    function _replaceIdPlaceholder(
        string memory uriTemplate,
        uint256 id
    ) internal pure returns (string memory) {
        bytes memory uriBytes = bytes(uriTemplate);
        bytes memory idBytes = bytes(_uintToString(id));
        bytes memory result;

        for (uint256 i = 0; i < uriBytes.length; i++) {
            if (
                i + 3 < uriBytes.length &&
                uriBytes[i] == "{" &&
                uriBytes[i + 1] == "i" &&
                uriBytes[i + 2] == "d" &&
                uriBytes[i + 3] == "}"
            ) {
                result = abi.encodePacked(result, idBytes);
                i += 3; // Skip {id}
            } else {
                result = abi.encodePacked(result, uriBytes[i]);
            }
        }

        return string(result);
    }

    function _uintToString(
        uint256 _i
    ) internal pure returns (string memory str) {
        if (_i == 0) return "0";
        uint256 temp = _i;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_i != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_i % 10)));
            _i /= 10;
        }
        str = string(buffer);
    }
}
