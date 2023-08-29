// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import { ExecutorParserLibWrapper } from "../wrappers/ExecutorParserLibWrapper.sol";

contract ExecutorParserLibTest is Test {

  /* ============ Vars ============ */

  ExecutorParserLibWrapper parser;

  bytes data;
  bytes executeData;

  /* ============ Set Up ============ */

  function setUp() public {
    parser = new ExecutorParserLibWrapper();
    data = data = abi.encode(address(this), uint256(1), bytes32(uint256(2)));
  }

  /* ============ messageId ============ */

  function testMessageId() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.messageId.selector), bytes32(uint256(2)), uint256(1), address(this));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (bytes32)), bytes32(uint256(2)));
  }

  function testMessageId_CalldataTooShortReturnsZero() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.messageId.selector), bytes32(uint256(2)), uint256(1));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (bytes32)), bytes32(uint256(0))); // zero
  }

  /* ============ fromChainId ============ */

  function testFromChainId() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.fromChainId.selector), bytes32(uint256(2)), uint256(1), address(this));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (uint256)), uint256(1));
  }

  function testFromChainId_CalldataTooShortReturnsZero() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.fromChainId.selector), uint256(1));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (uint256)), uint256(0)); // zero
  }

  /* ============ msgSender ============ */

  function testMsgSender() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.msgSender.selector), bytes32(uint256(2)), uint256(1), address(this));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (address)), address(this));
  }

  function testMsgSender_CalldataTooShortReturnsZero() public {
    executeData = abi.encodePacked(abi.encodeWithSelector(parser.msgSender.selector));
    (bool success, bytes memory result) = address(parser).call(executeData);
    assertTrue(success);
    assertEq(abi.decode(result, (address)), address(0));
  }

}