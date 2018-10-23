<template>
    <div id="app">
        <div className="block">
            <h4>Current Address</h4> &nbsp;
            <span v-if='this.address' ref="last-winner">{{this.address}}</span>
            <span v-else='this.address' ref="last-winner">loading...</span>
        </div>

        <div className="block">
            <h4>Number Of Bets</h4> &nbsp;
            <span v-if='this.address' ref="last-winner">{{this.numberOfBets}}</span>
            <span v-else='this.address' ref="last-winner">loading...</span>
        </div>

        <div className="block">
            <h4>Timer:</h4> &nbsp;
            <span ref="timer"> ...</span>
        </div>
        <div className="block">
            <h4>Last winner:</h4> &nbsp;
            <span ref="last-winner">{{this.lastWinner}}</span>
        </div>

        <h2>Vote for the next number</h2>
        <ul>
            <li @click="vote(1)"> 1</li>
            <li @click="vote(2)"> 2</li>
            <li @click="vote(3)"> 3</li>
            <li @click="vote(4)"> 4</li>
            <li @click="vote(5)"> 5</li>
            <li @click="vote(6)"> 6</li>
            <li @click="vote(7)"> 7</li>
            <li @click="vote(8)"> 8</li>
            <li @click="vote(9)"> 9</li>
            <li @click="vote(10)"> 10</li>
        </ul>
    </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import Web3 from 'web3'
import CasinoAbi from './CasinoAbi'

if(typeof window.web3 != 'undefined'){
    console.log("Using web3 detected from external source like Metamask")
    var web3 = new Web3(window.web3.currentProvider)
}else{
    var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))
}



const Casino = new web3.eth.Contract(CasinoAbi, '0xa4f60d72327ef9edc45d3bca51580f87af388d36')

export default {
    name: 'app',
    data: function(){
        return({
            lastWinner: 0,
            numberOfBets: 0,
            address: null,
            minimumBet: 0,
            totalBet: 0,
            maxAmountOfBets: 0,
        })
    },
    methods: {
        vote: function(value) {
            Casino.methods.bet(value).send({
                gas: 1000000,
                from: this.address,
                value: web3.utils.toWei(String(0.1), 'ether')
            })
        }
    },
    mounted: function(){
        web3.eth.getAccounts().then( (e) => { 
            this.address = e[0] 
            Casino.methods.numberOfBets().call({from: this.address}).then((e) => {
                this.numberOfBets = e
            })
        } )
    },
}
</script>

<style>
#app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
}
ul{
    list-style-type: none;
    padding-left: 0;
    display: flex;
}
li{
    padding: 40px;
    border: 2px solid rgb(30,134,255);
    margin-right: 5px;
    border-radius: 10px;
    cursor: pointer;
}
li:hover{
    background-color: rgb(30,134,255);
    color: white;
}
li:active{
    opacity: 0.7;
}
</style>
