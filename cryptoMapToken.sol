// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


contract TokenMe is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("CryptoMap", "CMAP")
        Ownable(initialOwner)
        ERC20Permit("CryptoMap")
    {
        _mint(initialOwner, 10 * 10**decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function get_user_balance() public view returns (bool) {
        if (balanceOf(msg.sender) > 0) {
            return true;
        }
        return false;
    }

    enum user_definition {
        Community,
        Dev,
        Worker,
        Investor,
        Company,
        Entrepreneur
    }

    struct Location {
        int32 latitude;
        int32 longitude;
    }

    struct User {
        user_definition user_type;
        Location gps_position;
        string tags;
    }

    mapping(address => User) user_data;

    address[] wallets;

    function contains(address addr) public view returns (bool) {
        for (uint256 i = 0; i < wallets.length; i++) {
            if (wallets[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function put_user(
        uint8 userCat,
        int32 lat,
        int32 long,
        string memory userTags
    ) public {
        require(
            balanceOf(msg.sender) > 0,
            "Wallet does not have CryptoMap Token"
        );

        Location memory location = Location({latitude: lat, longitude: long});

        User storage user = user_data[msg.sender];
        user.gps_position = location;
        user.user_type = user_definition(userCat);
        user.tags = userTags;

        if (!contains(msg.sender)) {
            wallets.push(msg.sender);
            // TODO emit()
        } else {
            // TODO emit()
        }
    }

    function get_users_id() public view returns (address[] memory) {
        require(wallets.length > 0, "No wallets are listed");
        return wallets;
    }

    function get_user_data_by(address wallet)
        public
        view
        returns (User memory)
    {
        require(contains(wallet), "This wallet is not listed");
        return user_data[wallet];
    }

    function refresh_user_list() public onlyOwner {
        for (uint256 j = 0; j < wallets.length; j++) {
            if (balanceOf(wallets[j]) == 0) {
                // TODO emit();
                delete wallets[j];
            }
        }
    }

}
