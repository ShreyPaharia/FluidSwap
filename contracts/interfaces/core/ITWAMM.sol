// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ITWAMM {

    /**
     * @notice swap assets over specificed amounts of blocks and slippage constraints
     * @dev calls swap function on uniswap pool via lazy exeuction after diving order into small parts
     * @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
     * @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
     * @param blocks amount of blocks to split order (t to t + blocks)
     */
    function longTermOrder(
        bool zeroForOne,
        int256 amountSpecified,
        uint256 blocks
    ) external;

    /**
     * @notice Swap token0 for token1, or token1 for token0
     * @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
     * @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
     * @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
     * value after the swap. If one for zero, the price cannot be greater than this value after the swap
     */
    function regularSwap(
        bool zeroForOne,
        bool isExactInput,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96
    ) external returns (int256 amount0, int256 amount1);

    /**
     * @notice Adds liquidity for the given recipient/tickLower/tickUpper position
     * @dev can only add liquidity using this function due to restricted token hooks
     * @param tickLower The lower tick of the position in which to add liquidity
     * @param tickUpper The upper tick of the position in which to add liquidity
     * @param amount The amount of liquidity to mint
     */
    function provideLP(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /**
     * @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
     * @dev Fees must be collected separately via a call to #collect
     * @param tickLower The lower tick of the position in which to add liquidity
     * @param tickUpper The upper tick of the position in which to add liquidity
     * @param amount The amount of liquidity to burn
     */
    function withdrawLP(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /**
     * @notice Collects tokens owed to a position
     * @param tickLower The lower tick of the position for which to collect fees
     * @param tickUpper The upper tick of the position for which to collect fees
     * @param amount0Requested How much token0 should be withdrawn from the fees owed
     * @param amount1Requested How much token1 should be withdrawn from the fees owed
     */
    function collect(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);
    
}
