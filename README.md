<p align="center"><img src="/Logo.PNG" align="center" width="400"></p>

<p  align="center">An AMM to enable large orders to be executed over multiple blocks! 🚀</p>

## Motivation
  Executing large orders on the current AMMs including Uniswap is very difficult. Large orders cause high movement in prices leading to an unfavourable price for the party swapping the asset. Not only that various attacks including sandwich attack are also possible in this case. In traditional exchanges brokerage firms solve this problem by executing the large order by dividing it into very small order and executing them algorithmically over time.

## Solution
  We are building a decentralized AMM on top of Uniswap V3. Users can take normal actions like swap and add/remove liquidity. On top of that users can also put in fluid orders (order to be executing over time). These orders don't lead to sudden movement in prices and are also safe from sandwich attacks.

## Architechture

- (coming soon)

### Tokens

- We use wrapped tokens to ensure that these tokens can only be transferred to or from the periphery contract	

### Periphery

- Uniswap periphery which interacts with Uniswap V3 pools to execute swaps and add/remove liquidity

### Fluid Swap Manager

- Contract which takes care of all the Fluid Swap Orders input onto the platform

## Various blockchain protocol integrations 

- (coming soon)
  
  
## Deployments 

- (coming soon)

