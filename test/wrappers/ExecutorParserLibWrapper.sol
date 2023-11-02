// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { ExecutorParserLib } from "../../src/libraries/ExecutorParserLib.sol";

contract ExecutorParserLibWrapper {
  function messageId() public pure returns (bytes32) {
    return ExecutorParserLib.messageId();
  }

  function fromChainId() public pure returns (uint256) {
    return ExecutorParserLib.fromChainId();
  }

  function msgSender() public pure returns (address payable) {
    return ExecutorParserLib.msgSender();
  }
}
