// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { MessageLib } from "../../src/libraries/MessageLib.sol";

contract MessageLibWrapper {
  function computeMessageId(
    uint256 nonce,
    address from,
    address to,
    bytes memory data
  ) external pure returns (bytes32) {
    return MessageLib.computeMessageId(nonce, from, to, data);
  }

  function computeMessageBatchId(
    uint256 nonce,
    address from,
    MessageLib.Message[] memory messages
  ) external pure returns (bytes32) {
    return MessageLib.computeMessageBatchId(nonce, from, messages);
  }

  function encodeMessage(
    address to,
    bytes memory data,
    bytes32 messageId,
    uint256 fromChainId,
    address from
  ) external pure returns (bytes memory) {
    return MessageLib.encodeMessage(to, data, messageId, fromChainId, from);
  }

  function encodeMessageBatch(
    MessageLib.Message[] memory messages,
    bytes32 messageId,
    uint256 fromChainId,
    address from
  ) external pure returns (bytes memory) {
    return MessageLib.encodeMessageBatch(messages, messageId, fromChainId, from);
  }

  function executeMessage(
    address to,
    bytes memory data,
    bytes32 messageId,
    uint256 fromChainId,
    address from,
    bool executedMessageId
  ) external {
    return MessageLib.executeMessage(to, data, messageId, fromChainId, from, executedMessageId);
  }

  function executeMessageBatch(
    MessageLib.Message[] memory messages,
    bytes32 messageId,
    uint256 fromChainId,
    address from,
    bool executedMessageId
  ) external {
    return
      MessageLib.executeMessageBatch(messages, messageId, fromChainId, from, executedMessageId);
  }
}
