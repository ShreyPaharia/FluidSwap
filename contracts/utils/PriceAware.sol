// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

abstract contract PriceAware {

    address public immutable oracle;
    address public immutable pool;

    constructor(address _oracle, address _pool) {
        oracle = _oracle;
        pool = _pool;
    }

}
