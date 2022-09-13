// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./PlayifyToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PlayifyExchange is Pausable, AccessControl {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint public rate;
  PlayifyToken public token;
  IERC20 public originalToken;
  

  constructor(
    address _admin,
    address _token,
    address _originalToken,
    uint _rate
  ) {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(PAUSER_ROLE, msg.sender);

    _grantRole(PAUSER_ROLE, _admin);
    rate = _rate;
    token = PlayifyToken(_token);
    originalToken = IERC20(_originalToken);
  }

  function buy(uint _amount) external whenNotPaused {
    require(_amount > 0,"AMOUNT ZERO");

    originalToken.transferFrom(msg.sender,address(this),_amount);
    token.mint(msg.sender,_amount * rate);
  }

  function sell(uint _amount) external whenNotPaused {
    require(_amount > 0,"AMOUNT ZERO");

    token.burnFrom(msg.sender,_amount);
    originalToken.transfer(msg.sender,_amount/rate);
  }

  function pause() public onlyRole(PAUSER_ROLE) {
      _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
      _unpause();
  }

}
