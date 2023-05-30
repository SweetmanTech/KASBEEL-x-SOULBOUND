// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {KasbeelSoulbound} from "../src/KasbeelSoulbound.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";

contract KasbeelSoulboundTest is DSTest {
    KasbeelSoulbound public kasbeelSoulbound;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_MINTER_ADDRESS =
        payable(address(0x111));

    function setUp() public {
        kasbeelSoulbound = new KasbeelSoulbound({
            _contractName: "Kasbeel Soulbound",
            _contractSymbol: "KASBEEL",
            _airdropRecipient: DEFAULT_MINTER_ADDRESS,
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _metadataRenderer: dummyRenderer,
            _initData: bytes(" ")
        });
    }

    function test_Erc721() public {
        assertEq("Kasbeel Soulbound", kasbeelSoulbound.name());
        assertEq("KASBEEL", kasbeelSoulbound.symbol());
    }

    function test_airdrop() public {
        assertEq(DEFAULT_MINTER_ADDRESS, kasbeelSoulbound.ownerOf(1));
    }

    function test_metadataRendererAddressInit() public {
        assertEq(
            address(dummyRenderer),
            address(kasbeelSoulbound.metadataRenderer())
        );
    }

    function test_Soulbound_blockTransfer() public {
        vm.prank(DEFAULT_MINTER_ADDRESS);
        vm.expectRevert(abi.encodeWithSignature("Kasbeel_Soulbound()"));
        kasbeelSoulbound.safeTransferFrom(
            DEFAULT_MINTER_ADDRESS,
            DEFAULT_OWNER_ADDRESS,
            1
        );
    }

    function test_TokenURI() public {
        assertEq(kasbeelSoulbound.tokenURI(1), "DUMMY");
    }
}
