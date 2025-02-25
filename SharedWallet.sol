// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
 /***   ///@tittle Shared_wallet
    ///@author Mentem Deus
    /***@notice this  contract that allows multiple users (or owners)
     to collectively manage and control a wallet.***/
     contract SharedWallet {
        event Deposit(address from, uint amount);
        event Withdraw(address to, uint amount);
        event TransferTo(address sender, address to, uint amount);
        address private _owner;

       ///@notice mapping so other addresses can interact with this wallet
        mapping(address => uint ) public _owners;
      

      /***@notice to interact with the wallet you need to be the owner, so added a require statement 
      then execute the function***/
        modifier IsOwner() {
            require(msg.sender == _owner);
            _;
        }
        /***@notice The validOwner modifier ensures that only authorized addresses 
        (either the primary owner or those listed in _owners)
         can execute the functions where this modifier is applied.***/
      modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender]== 1);
        _;
      }        ///@notice to ensure the creator is the owner 
               constructor ()  {
                _owner = msg.sender;


               }
               receive() external payable {
                emit Deposit(msg.sender, msg.value);
                }
 ///@notice this function is used to add owners to the wallet, and omly IsOwner can add  addresses
 
                function Addowner (address owner) public IsOwner{
                    //1 means enabled
                    _owners[owner]= 1;

                }
  ///@notice remove an owner from the wallet and only Isowner can remove addresses
    function RemoveOwner(address owner) public IsOwner {
        //0 means disabled              
              _owners[owner] = 0;

                }

                
              ///@notice to withdraw you have to be an owner and the balance of the address should be >= amount
                function withdraw (uint amount)  public  payable validOwner {
                    require(  address(this).balance >= amount, "insufficent balance ");
                    //send amount to the address 
                 (bool sent,) =     msg.sender.call{value:amount} ("");
                 require(sent, "not sent");

                 emit Withdraw( msg.sender, amount);

                }
             
            function transferto(address payable to, uint amount) public IsOwner {
                require(address(this).balance >= amount, "insufficent balance ");
                to.transfer(amount);
                emit TransferTo(msg.sender, to,  amount);

            }
            ///@notice to get the balance of the wallet
            function getbalance() public view returns (uint) {
                return address(this).balance;
            }
















     }