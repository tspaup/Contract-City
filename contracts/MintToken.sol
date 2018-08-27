pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./ERC223_ContractReceiver.sol";

contract MintToken is Ownable, ERC223_ContractReceiver{
    using SafeMath for uint256;

	bool public mintingFinished = false;
    uint256 _totalSupply = (100000000) * (10 ** 18); //  100 million total supply
    
    // Balances for each account
    mapping(address => uint256) balances;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event Transfer(address indexed _from, address indexed _to, uint256 _amount, bytes _data);
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

	modifier canMint(){
        require(!mintingFinished);
        _;
    }

    modifier hasMintPermission(){
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool){
        _totalSupply = _totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        
        bytes memory empty;
        emit Transfer(msg.sender, _to, _amount, empty);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}