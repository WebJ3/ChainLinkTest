// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts@1.4.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 提供基于30天滚动窗口计算的以太坊质押年化收益率（APR）
// 合约地址：https://docs.chain.link/data-feeds/rates-feeds/addresses?page=1&testnetPage=1
contract DataConsumer30DayEthApr {
    AggregatorV3Interface internal dataFeed;

    constructor() {
        dataFeed = AggregatorV3Interface(
            0xceA6Aa74E6A86a7f85B571Ce1C34f1A60B77CD29
        );
    }

    // answer:668599 / 100,000,000 = 0.668599%
    function getChainlinkDataFeedLatestRoundData() public view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        (
            roundId,
            answer,
            startedAt,
            updatedAt,
            answeredInRound
        ) = dataFeed.latestRoundData();
        
        // 直接返回元组（隐式返回所有命名的返回值）
    }

    function getHistoricalData(uint80 inRoundId) public view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        // prettier-ignore
        (
            roundId,
            answer,
            startedAt,
            updatedAt,
            answeredInRound
        ) = dataFeed.getRoundData(inRoundId);
    }
}