// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

import { IMessageDispatcher } from "./IMessageDispatcher.sol";
import { MessageLib, IBatchMessageDispatcher } from "./IBatchMessageDispatcher.sol";

/**
 * @title ERC-5164: Cross-Chain Execution Standard
 * @dev IMessageDispatcher interface extended to support Arbitrum two steps message dispatch.
 * @dev See https://eips.ethereum.org/EIPS/eip-5164
 */
interface IMessageDispatcherArbitrum is IMessageDispatcher, IBatchMessageDispatcher {
  /**
   * @notice Process message that has been dispatched.
   * @dev The transaction hash must match the one stored in the `dispatched` mapping.
   * @dev `from` is passed as `callValueRefundAddress` cause this address can cancel the retryably ticket.
   * @dev We store `message` in memory to avoid a stack too deep error.
   * @param messageId ID of the message to process
   * @param from Address who dispatched the `data`
   * @param to Address that will receive the message
   * @param data Data that was dispatched
   * @param refundAddress Address that will receive the `excessFeeRefund` amount if any
   * @param gasLimit Maximum amount of gas required for the `messages` to be executed
   * @param maxSubmissionCost Max gas deducted from user's L2 balance to cover base submission fee
   * @param gasPriceBid Gas price bid for L2 execution
   * @return Id of the retryable ticket that was created
   */
  function processMessage(
    bytes32 messageId,
    address from,
    address to,
    bytes calldata data,
    address refundAddress,
    uint256 gasLimit,
    uint256 maxSubmissionCost,
    uint256 gasPriceBid
  ) external payable returns (uint256);

  /**
   * @notice Process messages that have been dispatched.
   * @dev The transaction hash must match the one stored in the `dispatched` mapping.
   * @dev `from` is passed as `messageValueRefundAddress` cause this address can cancel the retryably ticket.
   * @dev We store `message` in memory to avoid a stack too deep error.
   * @param messageId ID of the messages to process
   * @param messages Array of messages being processed
   * @param from Address who dispatched the `messages`
   * @param refundAddress Address that will receive the `excessFeeRefund` amount if any
   * @param gasLimit Maximum amount of gas required for the `messages` to be executed
   * @param maxSubmissionCost Max gas deducted from user's L2 balance to cover base submission fee
   * @param gasPriceBid Gas price bid for L2 execution
   * @return Id of the retryable ticket that was created
   */
  function processMessageBatch(
    bytes32 messageId,
    MessageLib.Message[] calldata messages,
    address from,
    address refundAddress,
    uint256 gasLimit,
    uint256 maxSubmissionCost,
    uint256 gasPriceBid
  ) external payable returns (uint256);

  /**
   * @notice Get transaction hash for a single message.
   * @dev The transaction hash is used to ensure that only messages that were dispatched are processed.
   * @param messageId ID uniquely identifying the message that was dispatched
   * @param from Address who dispatched the message
   * @param to Address that will receive the message
   * @param data Data that was dispatched
   * @return bytes32 Transaction hash
   */
  function getMessageTxHash(
    bytes32 messageId,
    address from,
    address to,
    bytes calldata data
  ) external view returns (bytes32);

  /**
   * @notice Get transaction hash for a batch of messages.
   * @dev The transaction hash is used to ensure that only messages that were dispatched are processed.
   * @param messageId ID uniquely identifying the messages that were dispatched
   * @param from Address who dispatched the messages
   * @param messages Array of messages that were dispatched
   * @return bytes32 Transaction hash
   */
  function getMessageBatchTxHash(
    bytes32 messageId,
    address from,
    MessageLib.Message[] calldata messages
  ) external view returns (bytes32);
}
