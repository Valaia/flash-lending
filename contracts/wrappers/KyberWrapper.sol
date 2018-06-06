pragma solidity 0.4.24;

import "./ExchangeWrapper.sol";
import "../interface/Kyber.sol";

contract KyberWrapper is ExchangeWrapper {

    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    constructor(address _exchange) public {
        exchange = _exchange;
    }

    function getTokens(
        ERC20 dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
    )
        public
        payable
    {
        Kyber(exchange).trade.value(msg.value)(
            ETH_TOKEN_ADDRESS,
            msg.value,
            dest,
            destAddress,
            maxDestAmount,
            minConversionRate,
            walletId
        );
    }

    function getEther(
        ERC20 src,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
    )
        public
    {
        // Use the full balance of tokens transferred from the trade executor
        uint256 srcAmount = src.balanceOf(this);
        // Approve the exchange to transfer tokens from this contract to the reserve
        src.approve(exchange, srcAmount);

        Kyber(exchange).trade(
            src,
            srcAmount,
            ETH_TOKEN_ADDRESS,
            destAddress,
            maxDestAmount,
            minConversionRate,
            walletId
        );
    }

}