// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "forge-std/Test.sol";

import { ExecutorZeroAddress } from "../../src/abstract/ExecutorAware.sol";
import { ExecutorAwareHarness } from "../harness/ExecutorAwareHarness.sol";

contract ExecutorAwareTest is Test {
  /* ============ Events ============ */

  event SetTrustedExecutor(address indexed previousExecutor, address indexed newExecutor);

  /* ============ Vars ============ */

  ExecutorAwareHarness target;

  address executor;
  address executor2;

  /* ============ Set Up ============ */

  function setUp() public {
    executor = makeAddr("executor");
    executor2 = makeAddr("executor2");

    target = new ExecutorAwareHarness(executor);
  }

  /* ============ Constructor ============ */

  function testConstructor_ExecutorZeroAddress() public {
    vm.expectRevert(abi.encodeWithSelector(ExecutorZeroAddress.selector));
    new ExecutorAwareHarness(address(0));
  }

  /* ============ Executor ============ */

  function testIsTrustedExecutor() public {
    assertEq(target.isTrustedExecutor(address(this)), false);
    assertEq(target.isTrustedExecutor(address(0)), false);
    assertEq(target.isTrustedExecutor(executor2), false);
    assertEq(target.isTrustedExecutor(executor), true);
  }

  function testTrustedExecutor() public {
    assertEq(target.trustedExecutor(), executor);
  }

  function testSetTrustedExecutor_Success() public {
    assertEq(target.isTrustedExecutor(executor2), false);
    vm.expectEmit();
    emit SetTrustedExecutor(executor, executor2);
    target.setTrustedExecutor(executor2);
    assertEq(target.isTrustedExecutor(executor2), true);
  }

  function testSetTrustedExecutor_ExecutorZeroAddress() public {
    vm.expectRevert(abi.encodeWithSelector(ExecutorZeroAddress.selector));
    target.setTrustedExecutor(address(0));
  }
}
