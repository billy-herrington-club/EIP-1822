// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

abstract contract UUPSProxiable {
    //Pseudo-random slot to store implementation
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    //Emitted on implementation upgrade
    event Upgraded(address indexed implementation);

    /// @notice Returns implementation slot of the contract
    function proxiableUUID() external view virtual returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    /// @dev Checks the compatibility and stores new implementation. The check is
    /// performed by comparing bytes of _IMPLEMENTATION_SLOT
    function _setImplementation(address _implementation) internal virtual {
        require(
            UUPSProxiable(_implementation).proxiableUUID() ==
                _IMPLEMENTATION_SLOT,
            "UUPSProxiable: Implementation is not UUPSProxiable."
        );
        _setAddress(_IMPLEMENTATION_SLOT, _implementation);
    }

    /// @dev Low-level function to store address at certain storage slot
    function _setAddress(bytes32 slot, address data) internal {
        assembly {
            sstore(slot, data)
        }
    }

     /// @dev Low-level function to retrieve address from a storage slot
    function _getAddress(bytes32 slot) internal view returns (address data) {
        assembly {
            data := sload(slot)
        }
    }
}
