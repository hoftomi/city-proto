package com.hof.tronnelkul.game.engine;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class MoneyTest {
    @Test
    void coinsShowOnlyTheNonZeroDenominationsBiggestFirst() {
        assertEquals("4 [gold] 3 [silver] 5 [bronze]", Money.coins(435));
        assertEquals("4 [gold]", Money.coins(400));
        assertEquals("3 [silver] 5 [bronze]", Money.coins(35));
        assertEquals("4 [gold] 5 [bronze]", Money.coins(405));
        assertEquals("7 [bronze]", Money.coins(7));
        assertEquals("1234 [gold] 5 [silver]", Money.coins(123_450));
        assertEquals("0 [gold]", Money.coins(0));
    }

    @Test
    void negativeAmountsGetALeadingMinus() {
        assertEquals("−3 [silver]", Money.coins(-30));
        assertEquals("−4 [gold] 3 [silver] 5 [bronze]", Money.coins(-435));
    }

    @Test
    void signedAmountsShowThePlus() {
        assertEquals("+4 [gold] 5 [bronze]", Money.signed(405).text());
        assertEquals("−3 [silver]", Money.signed(-30).text());
        assertEquals("+0 [gold]", Money.signed(0).text());
        assertEquals("4 [gold]", Money.of(400).text());
        assertEquals("4 [gold]", Money.of(400).toString());
    }
}
