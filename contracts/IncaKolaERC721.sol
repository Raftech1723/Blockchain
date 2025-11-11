// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * =====================================================
 * 🥤 IncaKolaNFT - Colección Oficial (Ejemplo educativo)
 * =====================================================
 * - Basado en OpenZeppelin v4.9.0
 * - Cada NFT representa un coleccionable único de Inca Kola.
 * - Solo la empresa (owner) puede acuñar nuevos NFTs.
 * - Incluye pausado, quemado y metadatos IPFS.
 *
 * ⚠️ Este contrato es un ejemplo educativo y NO pertenece
 * oficialmente a la empresa Inca Kola ni a The Coca-Cola Company.
 */

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.0/contracts/token/ERC721/ERC721.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.0/contracts/access/Ownable.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.0/contracts/security/Pausable.sol";

contract IncaKolaNFT is ERC721, ERC721URIStorage, Ownable, Pausable {
    uint256 private _nextTokenId;

    event Minted(address indexed to, uint256 indexed tokenId, string uri);

    constructor() ERC721("Inca Kola NFT Collection", "INKNFT") {
        _nextTokenId = 1;
    }

    /**
     * @notice Crea (mint) un nuevo NFT exclusivo de Inca Kola.
     * @param to Dirección del destinatario.
     * @param uri URL o hash IPFS con la metadata del NFT.
     */
    function mintIncaNFT(address to, string memory uri) external onlyOwner {
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit Minted(to, tokenId, uri);
    }

    /**
     * @notice Pausa todas las transferencias.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice Reactiva las transferencias.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Hook interno para impedir transferencias durante pausa.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
        require(!paused(), "IncaKolaNFT: transfer paused");
    }

    /**
     * @dev Permite quemar (burn) un NFT.
     */
    function burn(uint256 tokenId) external {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Not authorized");
        _burn(tokenId);
    }

    // =====================================================
    //   Funciones requeridas por la herencia múltiple
    // =====================================================

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}