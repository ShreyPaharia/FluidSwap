// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "../interfaces/core/ITWAMM.sol";

import "../interfaces/uniswap/ISwapRouter.sol";
import "../interfaces/uniswap/IUniswapV3Pool.sol";
import "../interfaces/uniswap/IUniswapV3SwapCallback.sol";

import "../interfaces/common/IERC20.sol";

/// @notice remove abstract after implementing ITWAMM
abstract contract TWAMM is ITWAMM {

    struct FluidOrder {
        bool zeroForOne;
        uint256 amountPerBlock;
        address owner;
    }

    address public immutable v3Pool;
    uint256 public lastActivityBlock;
    uint256 public lastSwapBlock;

    uint256 public token0RatePerBlock;
    uint256 public token1RatePerBlock;

    uint256 public lastOrderNum;

    // mapping(address => uint256) public rateOfToken0PerBlock;
    // mapping(address => uint256) public rateOfToken1PerBlock;

    // mapping(address => uint256) public startBlock;
    // mapping(address => uint256) public endBlock;

    //End Block # => Index in active order array
    mapping(uint256 => uint256[]) public orderExpiryMap;

    //Array of order Nonces
    uint256[] public activeOrders;

    //Nonce => Fluid Order
    mapping(uint256 => FluidOrder) public orders;


    constructor(address _v3Pool) {
        v3Pool = _v3Pool;
    }

    function roundUp (uint256 numToRound, uint256 multiple) internal pure returns(uint256){
        uint256 remainder = numToRound % multiple;
        if(remainder==0) return numToRound;
        else return numToRound + multiple - remainder;
    }

    function longTermOrder(bool zeroForOne, uint256 amountSpecified, uint256 blocks) external {
        uint256 amountPerBlock = amountSpecified/blocks;
        FluidOrder memory order = FluidOrder(zeroForOne,amountPerBlock,msg.sender);
        uint256 endBlockNumber = roundUp(block.number,50) + blocks;

        lastOrderNum++;
        activeOrders.push(lastOrderNum);
        orderExpiryMap[endBlockNumber].push(activeOrders.length-1);

        orders[lastOrderNum]=order;


        if(zeroForOne) {
            token1RatePerBlock += amountPerBlock;
        } else {
            token0RatePerBlock -= amountPerBlock;
        }
    }

    function uniV3Swap(bool zeroForOne, bool isExactInput, uint256 amountSpecified, uint256 sqrtPriceLimitX96) internal{
        //TODO
    }

    function remove(uint256[] storage array, uint256 indexToRemove) internal {
        require(indexToRemove>array.length-1);
        
        array[indexToRemove] = array[array.length-1];
        delete array[array.length-1];
    }

    function expireLongOrders() internal {
        uint256[] storage ordersToExpire = orderExpiryMap[block.number];
        
        for(uint i=0; i<ordersToExpire.length; i++){

            FluidOrder storage order = orders[activeOrders[ordersToExpire[i]]];
            remove(activeOrders,ordersToExpire[i]);
            if(order.zeroForOne){
                token1RatePerBlock-=order.amountPerBlock;
            } else {
                token0RatePerBlock-=order.amountPerBlock;
            }

        }

    }

    function regularSwap(bool zeroForOne, bool isExactInput, uint256 amountSpecified, uint256 sqrtPriceLimitX96) external {
        uint256 token0ToSwap = token0RatePerBlock*(block.number-lastSwapBlock);
        uint256 token1ToSwap = token1RatePerBlock*(block.number-lastSwapBlock);

        uniV3Swap(false, false, token0ToSwap, sqrtPriceLimitX96);
        uniV3Swap(true, false, token1ToSwap, sqrtPriceLimitX96);

        uniV3Swap(zeroForOne, isExactInput, amountSpecified, sqrtPriceLimitX96);

        expireLongOrders();
    }
}
