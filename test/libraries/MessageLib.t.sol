// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import { Test } from "forge-std/Test.sol";

import {
  IMessageExecutor,
  ISingleMessageExecutor
} from "../../src/interfaces/extensions/ISingleMessageExecutor.sol";
import { IBatchMessageExecutor } from "../../src/interfaces/extensions/IBatchMessageExecutor.sol";

import { MessageLib, MessageLibWrapper } from "../wrappers/MessageLibWrapper.sol";

contract MessageLibTest is Test {
  /* ============ Vars ============ */

  MessageLibWrapper public messageLib;

  uint256 public nonce;
  uint256 public fromChainId = 1;
  address public from = address(this);
  address public to = makeAddr("to");
  bytes public data;
  MessageLib.Message[] public messages;

  /* ============ Set Up ============ */

  function setUp() public {
    messageLib = new MessageLibWrapper();

    data = abi.encode(address(this), uint256(1), bytes32(uint256(2)));

    messages.push(MessageLib.Message({ to: to, data: data }));
    messages.push(MessageLib.Message({ to: to, data: data }));
  }

  /* ============ compute ============ */
  function testComputeMessageId() public {
    assertEq(
      messageLib.computeMessageId(nonce, from, to, data),
      keccak256(abi.encode(nonce, from, to, data))
    );
  }

  function testComputeMessageBatchId() public {
    assertEq(
      messageLib.computeMessageBatchId(nonce, from, messages),
      keccak256(abi.encode(nonce, from, messages))
    );
  }

  /* ============ encode ============ */
  function testEncodeMessage() public {
    bytes32 _messageId = messageLib.computeMessageId(nonce, from, to, data);

    assertEq(
      messageLib.encodeMessage(to, data, _messageId, fromChainId, from),
      abi.encodeCall(
        ISingleMessageExecutor.executeMessage,
        (to, data, _messageId, fromChainId, from)
      )
    );
  }

  function testEncodeMessageBatch() public {
    bytes32 _messageId = messageLib.computeMessageBatchId(nonce, from, messages);

    assertEq(
      messageLib.encodeMessageBatch(messages, _messageId, fromChainId, from),
      abi.encodeCall(
        IBatchMessageExecutor.executeMessageBatch,
        (messages, _messageId, fromChainId, from)
      )
    );
  }

  /* ============ executeMessage ============ */
  function testExecuteMessage() public {
    bytes32 _messageId = messageLib.computeMessageId(nonce, from, to, data);
    bytes memory _callData = abi.encodePacked(data, _messageId, fromChainId, from);

    vm.mockCall(to, _callData, abi.encode("returnData"));

    vm.expectCall(to, _callData);
    messageLib.executeMessage(to, data, _messageId, fromChainId, from, false);
  }

  function testExecuteMessageIdAlreadyExecuted() public {
    bytes32 _messageId = messageLib.computeMessageId(nonce, from, to, data);

    vm.expectRevert(
      abi.encodeWithSelector(IMessageExecutor.MessageIdAlreadyExecuted.selector, _messageId)
    );
    messageLib.executeMessage(to, data, _messageId, fromChainId, from, true);
  }

  function testExecuteMessageNoContractAtTo() public {
    bytes32 _messageId = messageLib.computeMessageId(nonce, from, to, data);

    vm.expectRevert(bytes("MessageLib/no-contract-at-to"));
    messageLib.executeMessage(to, data, _messageId, fromChainId, from, false);
  }

  function testExecuteMessageFailure() public {
    bytes32 _messageId = messageLib.computeMessageId(nonce, from, to, data);
    bytes memory _callData = abi.encodePacked(data, _messageId, fromChainId, from);
    bytes memory _callReturnData = abi.encode("returnData");

    vm.mockCall(to, _callData, _callReturnData);
    vm.mockCallRevert(to, _callData, _callReturnData);

    vm.expectRevert(
      abi.encodeWithSelector(IMessageExecutor.MessageFailure.selector, _messageId, _callReturnData)
    );

    messageLib.executeMessage(to, data, _messageId, fromChainId, from, false);
  }

  /* ============ executeMessageBatch ============ */
  function testExecuteMessageBatch() public {
    bytes32 _messageId = messageLib.computeMessageBatchId(nonce, from, messages);
    bytes memory _callData = abi.encodePacked(data, _messageId, fromChainId, from);

    vm.mockCall(to, _callData, abi.encode("returnData"));

    vm.expectCall(to, _callData);
    vm.expectCall(to, _callData);

    messageLib.executeMessageBatch(messages, _messageId, fromChainId, from, false);
  }

  function testExecuteMessageBatchIdAlreadyExecuted() public {
    bytes32 _messageId = messageLib.computeMessageBatchId(nonce, from, messages);

    vm.expectRevert(
      abi.encodeWithSelector(IMessageExecutor.MessageIdAlreadyExecuted.selector, _messageId)
    );

    messageLib.executeMessageBatch(messages, _messageId, fromChainId, from, true);
  }

  function testExecuteMessageBatchNoContractAtTo() public {
    bytes32 _messageId = messageLib.computeMessageBatchId(nonce, from, messages);

    vm.expectRevert(bytes("MessageLib/no-contract-at-to"));
    messageLib.executeMessageBatch(messages, _messageId, fromChainId, from, false);
  }

  function testExecuteMessageBatchFailure() public {
    bytes32 _messageId = messageLib.computeMessageBatchId(nonce, from, messages);
    bytes memory _callData = abi.encodePacked(data, _messageId, fromChainId, from);
    bytes memory _callReturnData = abi.encode("returnData");

    vm.mockCall(to, _callData, _callReturnData);
    vm.mockCallRevert(to, _callData, _callReturnData);

    vm.expectRevert(
      abi.encodeWithSelector(
        IBatchMessageExecutor.MessageBatchFailure.selector,
        _messageId,
        0,
        _callReturnData
      )
    );

    messageLib.executeMessageBatch(messages, _messageId, fromChainId, from, false);
  }
}
