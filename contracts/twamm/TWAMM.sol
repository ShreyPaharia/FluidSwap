// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "../interfaces/core/ITWAMM.sol";

import "../interfaces/uniswap/ISwapRouter.sol";
import "../interfaces/uniswap/IUniswapV3Pool.sol";
import "../interfaces/uniswap/IUniswapV3SwapCallback.sol";

import "../interfaces/common/IERC20.sol";

import "../utils/WrapUtils.sol";

/// @notice remove abstract after implementing ITWAMM
abstract contract TWAMM is ITWAMM, WrapUtils {

    address public immutable v3Pool;
    uint256 public lastActivityBlock;

    uint256 public instantaneousRateOfToken0PerBlock;
    uint256 public instantaneousRateOfToken1PerBlock;

    mapping(address => uint256) public rateOfToken0PerBlock;
    mapping(address => uint256) public rateOfToken1PerBlock;

    mapping(address => uint256) public startBlock;
    mapping(address => uint256) public endBlock;
    constructor(address _v3Pool) {
        v3Pool = _v3Pool;
    }
}
