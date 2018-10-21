pragma solidity 0.4.25;
contract Casino {
   address public owner;
   uint256 public minimumBet;
   uint256 public totalBet;
   uint256 public numberOfBets;
   uint256 public maxAmountOfBets = 3;
   address[] public players;
   struct Player {
      uint256 amountBet;
      uint256 numberSelected;
   }

   mapping(address => Player) public playerInfo;
   function() public payable {}
   constructor(uint256 _minimumBet) public {
      owner = msg.sender;
      if(_minimumBet != 0 ) minimumBet = _minimumBet;
   }
   function kill() public {
      if(msg.sender == owner) selfdestruct(owner);
   }
   function checkPlayerExists(address player) public constant returns(bool){
      for(uint256 i = 0; i < players.length; i++){
         if(players[i] == player) return true;
      }
      return false;
   }

   function bet(uint256 numberSelected) public payable {
      require(!checkPlayerExists(msg.sender));
      require(numberSelected >= 1 && numberSelected <= 10);
      require(msg.value >= minimumBet);
      playerInfo[msg.sender].amountBet = msg.value;
      playerInfo[msg.sender].numberSelected = numberSelected;
      numberOfBets++;
      players.push(msg.sender);
      totalBet += msg.value;
   }


   // Warn: insecure random 
   function generateNumberWinner() public {
      uint256 numberGenerated = block.number % 10 + 1; // This isn't secure
      distributePrizes(numberGenerated);
   }

   function distributePrizes(uint256 numberWinner) public {
      address[3] memory winners;
      uint256 count = 0; 
      for(uint256 i = 0; i < players.length; i++){
         address playerAddress = players[i];
         if(playerInfo[playerAddress].numberSelected == numberWinner){
            winners[count] = playerAddress;
            count++;
         }
         delete playerInfo[playerAddress];
      }
      players.length = 0;
      uint256 winnerEtherAmount = totalBet / winners.length;
      for(uint256 j = 0; j < count; j++){
         if(winners[j] != address(0))
         winners[j].transfer(winnerEtherAmount);
      }
   }
}
