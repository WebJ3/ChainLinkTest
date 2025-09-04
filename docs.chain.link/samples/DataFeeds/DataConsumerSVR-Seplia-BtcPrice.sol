// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts@1.4.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


/**
Smart Value Recapture智能价值回收数据源
https://docs.chain.link/data-feeds/svr-feeds
数据的生成和签名：价格数据始终由去中心化的 Chainlink 预言机网络在链下生成、聚合并完成密码学签名。搜索者无法伪造或篡改这个数据。
更新触发者	Chainlink 预言机节点 (按心跳或偏差阈值触发)	搜索者 (通过竞拍获得触发权限)
核心经济机制:预言机节点支付Gas费，协议支付服务费用	搜索者竞拍支付Gas费和溢价，溢价部分在协议和Chainlink网络间分配

搜索者的角色：搜索者只是通过竞拍，获得了将这份已经由权威生成并签名好的数据“广播”到链上的权利。他们更像是“信使”，而不是“新闻制造者”。


交易的原子性：获胜搜索者发出的交易是“原子化”的，意味着它包含两个不可分割的操作：
    操作一：调用 SVR Feed 合约，验证预言机签名并更新价格。
    操作二：立即执行自己的清算逻辑。

这样设计的好处是：
    安全可信：价格数据的真实性由 Chainlink 网络保证，搜索者无法作恶。
    公平竞争：所有搜索者竞争的是同一个权威数据的上链权，起跑线是公平的。
    效率最高：从价格更新到清算完成在一个交易内完成，速度最快，避免了被其他机器人抢跑的风险。
**/

contract SVRConsumer {
    AggregatorV3Interface internal svrFeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43， SVR aggregator's address
     */
    constructor() {
        svrFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    /**
     * Returns the latest answer.
     */
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
        ) = svrFeed.latestRoundData();
        
        // 直接返回元组（隐式返回所有命名的返回值）
    }

     /**
     * Returns historical data for a round ID.
     * roundId is NOT incremental. Not all roundIds are valid.
     * You must know a valid roundId before consuming historical data.
     *
     * ROUNDID VALUES:
     *    InValid:      18446744073709562300
     *    Valid:        18446744073709554683
     *
     * @dev A timestamp with zero value means the round is not complete and should not be used.
     */
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
        ) = svrFeed.getRoundData(inRoundId);
    }
}