// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ClickerV2 {
    address public owner;
    uint256 public totalClicks;
    bool public gameActive;

    struct UserStats {
        uint256 clicks;
        uint256 lastClick;
        uint256 streak;
        uint256 bestStreak;
    }

    mapping(address => UserStats) public userStats;

    event Clicked(address indexed user, uint256 totalClicks, uint256 streak);
    event GameStatusChanged(bool active);

    modifier onlyOwner() { require(msg.sender == owner, "Not authorized"); _; }
    modifier whenActive() { require(gameActive, "Game paused"); _; }

    constructor() {
        owner = msg.sender;
        gameActive = true;
    }

    function click() external whenActive {
        UserStats storage stats = userStats[msg.sender];
        uint256 blocksSince = block.number - stats.lastClick;
        uint256 newStreak = blocksSince <= 10 ? stats.streak + 1 : 1;

        stats.clicks++;
        stats.lastClick = block.number;
        stats.streak = newStreak;
        if (newStreak > stats.bestStreak) stats.bestStreak = newStreak;

        totalClicks++;
        emit Clicked(msg.sender, totalClicks, newStreak);
    }

    function getUserStats(address user) external view returns (uint256 clicks, uint256 lastClick, uint256 streak, uint256 bestStreak) {
        UserStats memory s = userStats[user];
        return (s.clicks, s.lastClick, s.streak, s.bestStreak);
    }

    function setGameActive(bool _active) external onlyOwner {
        gameActive = _active;
        emit GameStatusChanged(_active);
    }
}
