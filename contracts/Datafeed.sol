// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Datafeed {
   
    // contract owner address
    address private owner;

    struct SingleAssetData {
        uint32 value;      // price value
        uint256 timestamp;  // time when data pulled
        uint32 sourceId;   // id from where data is pulled
    }

    // mapping single asset symbol with its data 
    mapping(string => SingleAssetData) priceData;

    // mapps account address with true/false value, where true is authorized and false is not
    mapping(address => bool) authorization;

    // modifier to check address matches owner address
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not Owner!");
        _;
    }
    
    modifier isAuthorized(address _addr) {
        require(authorization[_addr] == true || msg.sender == owner, "User is not authorized!");
        _;
    }

    // event when request 
    event RequestFulfilled(string indexed symbol, uint32 indexed price);

    // event when new user is authorized
    event UserAuthorized(address _addr);
    
    constructor() {
        owner = msg.sender;
    }
    
    function requestPrice(
        string memory _symbol, 
        uint32 _value, 
        uint256 _timestamp, 
        uint8 _sourceId
    ) 
        public 
        isAuthorized(msg.sender) 
    {
        SingleAssetData storage data = priceData[_symbol];
        data.value = _value;
        data.timestamp = _timestamp;
        data.sourceId = _sourceId;

        emit RequestFulfilled(_symbol, _value);
    }

    function getPrice(string memory _symbol) public view returns (uint32) {
        uint32 price = priceData[_symbol].value;
        return price;
    }

    function authorize(address _addr) public isOwner() {
        require(_addr != address(0), "Zero address provided!");
        authorization[_addr] = true;
        emit UserAuthorized(_addr);
    }

    function checkAuthorization(address _addr) public view returns (bool) {
        return authorization[_addr];
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}


// bytes32 internal specID;
// bytes32 public currentPrice;
    
// uint256 constant private ORACLE_PAYMENT = 1 * XDC;