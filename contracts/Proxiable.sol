// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract UUPSProxiable {
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    ///@dev Emitted on implementation upgrade
    event Upgraded(address indexed implementation);

    error ImplementationSlotNotCompatible();

    function _setImplementation(address _implementation) internal virtual {
        if (
            UUPSProxiable(_implementation).proxiableUUID() !=
            _IMPLEMENTATION_SLOT
        ) {
            revert ImplementationSlotNotCompatible();
        }
        _setAddress(_IMPLEMENTATION_SLOT, _implementation);
    }

    function proxiableUUID() external view virtual returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    function _setAddress(bytes32 slot, address data) internal {
        assembly {
            sstore(slot, data)
        }
    }

    function _getAddress(bytes32 slot) internal view returns (address data) {
        assembly {
            data := sload(slot)
        }
    }
}
