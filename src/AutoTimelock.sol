// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract AutoTimelock is AutomationCompatibleInterface {
    address public timelock;
    uint256 public constant DELAY = 300;
    
    constructor(address _timelock) {
        timelock = _timelock;
    }

    // checkUpKeep()：在链下间隔执行调用该函数， 该方法返回一个布尔值，告诉网络是否需要自动化执行。
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool shouldTransferFunds, bytes memory /* performData */)
    {
        if (block.timestamp % DELAY == 0) {
            shouldTransferFunds = true;
        } else {
            shouldTransferFunds = false;
        }
    }

    // performUpKeep()：这个方法接受从checkUpKeep()方法返回的信息作为参数。Chainlink Automation 会触发对它的调用。函数应该先进行一些检查，再执行链上其他计算。
    function performUpkeep(bytes calldata /* performData */) external override {
        bytes memory payload = abi.encodeWithSignature("executeV2(address)",address(this));
        (bool success, ) = timelock.call(payload);
        require(success, "Transfer failed");
    }

    receive() external payable {}
}