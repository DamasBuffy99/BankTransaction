// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract BankTransaction{
    
    struct BankTransaction{
        string paymentID; //payment identifier (combination of letters and digits)
        string clientID; //client identifier (combination of letters and digits)
        string recipientID; //recipient identifier
        uint paymentAmount; //amount of the payment
        uint paymentTime; //time of the payment
        string paymentNote; //note to the payment
    }

    uint public count;
    uint public randNonce;
    mapping(address => string) public clientIDTable; //Get the identifier of client/recipient from his address
    mapping(string => uint) public idRegister; //Get the ranking of a paymentID in the bank table
    mapping(string => uint[]) public allTransactions; //List of transactins performed by a client 
    BankTransaction[] public bank;

    function addPayments(uint256 _amount, address _recipient,string memory _paymentNote) public {
        uint op = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % 5;
        randNonce++;
        string memory paymentID = Strings.toString(op);
        idRegister[paymentID] = count ; //new BankTransaction ID

        string memory clientName;
        clientName = clientIDTable[msg.sender];
        allTransactions[clientName].push(count);
        count++;
        bank.push(
            BankTransaction(
                paymentID,
                clientName,
                clientIDTable[_recipient],
                _amount,            
                block.timestamp,
                _paymentNote
            )
        );
    }

    function getInformations(string memory _paymentID) public view returns(BankTransaction memory){
        return bank[idRegister[_paymentID]];
    }

    function gettingAllPayments(address _particular) public returns(uint[] memory){
        uint[] memory list;
        list = allTransactions[clientIDTable[_particular]]; //array of uint ; example([1;5;9])
        /**BankTransaction[] memory payments;
        for(uint i = 0; i < list.length; i++){
            payments.push(bank[list[i]]);
        }*/
        return list; //return the transctionsID made
    }
}