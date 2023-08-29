// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ExecutorAware } from "../../src/abstract/ExecutorAware.sol";

contract ExecutorAwareHarness is ExecutorAware {
  
  constructor(address _executor) ExecutorAware(_executor) { }

  function setTrustedExecutor(address _executor) external {
    _setTrustedExecutor(_executor);
  }

}