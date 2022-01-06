pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PAW is ERC20, Ownable
{
	address public treasury = address(0x0a05FF9631F72D500FEb1A42C40c0c756d867A98);

	constructor() ERC20 ('Paw', 'PAW') {
		_mint(_msgSender(), 10 ** 12 * 10 ** 18);
	}

	function _transfer(address sender, address recipient, uint256 amount) internal override {
		uint treasuryTax = (amount * 100) / 10000;
		super._transfer(sender, treasury, treasuryTax);
		uint burnAmount = (amount * 150) / 10000;
		_burn(sender, burnAmount);
		super._transfer(sender, recipient, amount - burnAmount - treasuryTax);
	}

	function migrateTreasury(address newTreasury) public onlyOwner {
		treasury = newTreasury;
	}
}