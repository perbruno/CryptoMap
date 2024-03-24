// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// The Scroll Messenger interface is the same on both L1 and L2, it allows sending cross-chain transactions
// Let's import it directly from the Scroll Contracts library
import "@scroll-tech/contracts@0.1.0/libraries/IScrollMessenger.sol";

contract CheckWallets {
  function executeFunctionCrosschain(
    address scrollMessengerAddress,
    address targetAddress,
    uint256 value,
    uint32 gasLimit
  ) public payable {
    IScrollMessenger scrollMessenger = IScrollMessenger(scrollMessengerAddress);
    // sendMessage is able to execute any function by encoding the abi using the encodeWithSignature function
    scrollMessenger.sendMessage{ value: msg.value }(
      targetAddress,
      value,
      abi.encodeWithSignature("refresh_user_list()"),
      gasLimit,
      msg.sender
    );
  }
}