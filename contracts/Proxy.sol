// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Proxy {
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
  //0x8129fc1c
    constructor(bytes memory constructData, address implementation) {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, implementation)
        }
        (bool success, ) = implementation.delegatecall(constructData);
        require(success, "Unsuccessful construct");
    }

    fallback() external payable {
        assembly {
            let implementation := sload(_IMPLEMENTATION_SLOT)
            calldatacopy(0x0, 0x0, calldatasize())
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
