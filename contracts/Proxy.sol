// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

contract Proxy {
    //Pseudo-random slot to store implementation
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /// @dev Sets implementation, admin, and initializes implementation
    constructor(address _implementation, bytes memory _data) {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, _implementation)
        }
        (bool success, ) = _implementation.delegatecall(_data);
        require(success, "Unsuccessful construct");
    }

     /// @dev Fallback function that performs delegatecall to the contract that was loaded from
    /// implementation slot
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
