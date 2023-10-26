// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { ExecutorParserLib } from "../../src/libraries/ExecutorParserLib.sol";

contract ExecutorParserLibWrapper {
  function messageId() public pure returns (bytes32 _messageId) {
    _messageId = ExecutorParserLib.messageId();
  }

  function fromChainId() public pure returns (uint256 _fromChainId) {
    _fromChainId = ExecutorParserLib.fromChainId();
  }

  function msgSender() public pure returns (address payable _sender) {
    _sender = ExecutorParserLib.msgSender();
  }
}
