// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

// ENS Registry Contract
interface ENS {
    function resolver(bytes32 node) external view returns (Resolver);
}

// Chainlink Resolver
interface Resolver {
    function addr(bytes32 node) external view returns (address);
}

// Consumer contract
contract ENSConsumer {
    ENS ens;

    // ENS registry address: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
    constructor() {
        address ensAddress = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
        ens = ENS(ensAddress);
    }

    // Use ID Hash instead of readable name
    // ETH / USD hash: 0xf599f4cd075a34b92169cf57271da65a7a936c35e3f31e854447fbb3e7eb736d
    function resolve(bytes32 node) public view returns (address) {
        Resolver resolver = ens.resolver(node);
        return resolver.addr(node);
    }

    // 'eth-usd.data.eth'域名绑定0x10E7e7D64d7dA687f7DcF8443Df58A0415329b15合约地址
    // 'eth-usd.data.eth'对应的hash是0xf599f4cd075a34b92169cf57271da65a7a936c35e3f31e854447fbb3e7eb736d
    // 这个哈希就是通过namehash算法计算得到的。但是，合约内部不能直接从一个字符串计算出namehash，因为namehash算法需要递归地进行哈希，这在Solidity中计算成本很高（而且需要处理字符串和递归）。
    // 因此，通常我们在链下计算好namehash，然后将哈希值作为参数传递给合约函数
    function resoleFixed() public view returns (address) {
        bytes32 node = 0xf599f4cd075a34b92169cf57271da65a7a936c35e3f31e854447fbb3e7eb736d;
        Resolver resolver = ens.resolver(node);
        return resolver.addr(node);
    }
}
