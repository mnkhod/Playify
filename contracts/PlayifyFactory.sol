// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./PlayifyToken.sol";
import "./PlayifyExchange.sol";

contract PlayifyFactory {
  PlayifyToken public token;
  PlayifyExchange public exchange;
  
  constructor(
      string memory _name,
      string memory _symbol,
      address _admin,
      address _originalToken,
      uint _rate
  ) {
    token = new PlayifyToken(_name,_symbol,_admin);
    exchange = new PlayifyExchange(_admin,address(token),_originalToken,_rate);

    token.grantRole(keccak256("MINTER_ROLE"),address(exchange));
  }

}
