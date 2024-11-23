// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";
import {MintMoodNFT, FlipMoodNFT} from "../../script/Interactions.s.sol";

contract MoodNFTTest is Test {

    enum Mood {
        HAPPY,
        SAD
    }

    MoodNFT public moodNFT;
    DeployMoodNFT public deployer;

    address USER = makeAddr("user");

    string public constant HAPPY_MOOD_SVG_URI = "data:application/json;base64,eyJuYW1lOiAiTW9vZE5GVCIsIGRlc2NyaXB0aW9uOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgeW91ciBtb29kISIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJNb29kIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6IGRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjJhV1YzUW05NFBTSXdJREFnTWpBd0lESXdNQ0lnZDJsa2RHZzlJalF3TUNJZ0lHaGxhV2RvZEQwaU5EQXdJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQanhqYVhKamJHVWdZM2c5SWpFd01DSWdZM2s5SWpFd01DSWdabWxzYkQwaWVXVnNiRzkzSWlCeVBTSTNPQ0lnYzNSeWIydGxQU0ppYkdGamF5SWdjM1J5YjJ0bExYZHBaSFJvUFNJeklpOCtQR2NnWTJ4aGMzTTlJbVY1WlhNaVBqeGphWEpqYkdVZ1kzZzlJamN3SWlCamVUMGlPRElpSUhJOUlqRXlJaTgrUEdOcGNtTnNaU0JqZUQwaU1USTNJaUJqZVQwaU9ESWlJSEk5SWpFeUlpOCtQQzluUGp4d1lYUm9JR1E5SW0weE16WXVPREVnTVRFMkxqVXpZeTQyT1NBeU5pNHhOeTAyTkM0eE1TQTBNaTA0TVM0MU1pMHVOek1pSUhOMGVXeGxQU0ptYVd4c09tNXZibVU3SUhOMGNtOXJaVG9nWW14aFkyczdJSE4wY205clpTMTNhV1IwYURvZ016c2lMejQ4TDNOMlp6ND0ifQ==";
    string public constant SAD_MOOD_SVG_URI = "data:application/json;base64,eyJuYW1lOiAiTW9vZE5GVCIsIGRlc2NyaXB0aW9uOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgeW91ciBtb29kISIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJNb29kIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6IGRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEQ5NGJXd2dkbVZ5YzJsdmJqMGlNUzR3SWlCemRHRnVaR0ZzYjI1bFBTSnVieUkvUGdvOGMzWm5JSGRwWkhSb1BTSXhNREkwY0hnaUlHaGxhV2RvZEQwaU1UQXlOSEI0SWlCMmFXVjNRbTk0UFNJd0lEQWdNVEF5TkNBeE1ESTBJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQZ29nSUR4d1lYUm9JR1pwYkd3OUlpTXpNek1pSUdROUlrMDFNVElnTmpSRE1qWTBMallnTmpRZ05qUWdNalkwTGpZZ05qUWdOVEV5Y3pJd01DNDJJRFEwT0NBME5EZ2dORFE0SURRME9DMHlNREF1TmlBME5EZ3RORFE0VXpjMU9TNDBJRFkwSURVeE1pQTJOSHB0TUNBNE1qQmpMVEl3TlM0MElEQXRNemN5TFRFMk5pNDJMVE0zTWkwek56SnpNVFkyTGpZdE16Y3lJRE0zTWkwek56SWdNemN5SURFMk5pNDJJRE0zTWlBek56SXRNVFkyTGpZZ016Y3lMVE0zTWlBek56SjZJaTgrQ2lBZ1BIQmhkR2dnWm1sc2JEMGlJMFUyUlRaRk5pSWdaRDBpVFRVeE1pQXhOREJqTFRJd05TNDBJREF0TXpjeUlERTJOaTQyTFRNM01pQXpOekp6TVRZMkxqWWdNemN5SURNM01pQXpOeklnTXpjeUxURTJOaTQySURNM01pMHpOekl0TVRZMkxqWXRNemN5TFRNM01pMHpOeko2VFRJNE9DQTBNakZoTkRndU1ERWdORGd1TURFZ01DQXdJREVnT1RZZ01DQTBPQzR3TVNBME9DNHdNU0F3SURBZ01TMDVOaUF3ZW0wek56WWdNamN5YUMwME9DNHhZeTAwTGpJZ01DMDNMamd0TXk0eUxUZ3VNUzAzTGpSRE5qQTBJRFl6Tmk0eElEVTJNaTQxSURVNU55QTFNVElnTlRrM2N5MDVNaTR4SURNNUxqRXRPVFV1T0NBNE9DNDJZeTB1TXlBMExqSXRNeTQ1SURjdU5DMDRMakVnTnk0MFNETTJNR0U0SURnZ01DQXdJREV0T0MwNExqUmpOQzQwTFRnMExqTWdOelF1TlMweE5URXVOaUF4TmpBdE1UVXhMalp6TVRVMUxqWWdOamN1TXlBeE5qQWdNVFV4TGpaaE9DQTRJREFnTUNBeExUZ2dPQzQwZW0weU5DMHlNalJoTkRndU1ERWdORGd1TURFZ01DQXdJREVnTUMwNU5pQTBPQzR3TVNBME9DNHdNU0F3SURBZ01TQXdJRGsyZWlJdlBnb2dJRHh3WVhSb0lHWnBiR3c5SWlNek16TWlJR1E5SWsweU9EZ2dOREl4WVRRNElEUTRJREFnTVNBd0lEazJJREFnTkRnZ05EZ2dNQ0F4SURBdE9UWWdNSHB0TWpJMElERXhNbU10T0RVdU5TQXdMVEUxTlM0MklEWTNMak10TVRZd0lERTFNUzQyWVRnZ09DQXdJREFnTUNBNElEZ3VOR2cwT0M0eFl6UXVNaUF3SURjdU9DMHpMaklnT0M0eExUY3VOQ0F6TGpjdE5Ea3VOU0EwTlM0ekxUZzRMallnT1RVdU9DMDRPQzQyY3preUlETTVMakVnT1RVdU9DQTRPQzQyWXk0eklEUXVNaUF6TGprZ055NDBJRGd1TVNBM0xqUklOalkwWVRnZ09DQXdJREFnTUNBNExUZ3VORU0yTmpjdU5pQTJNREF1TXlBMU9UY3VOU0ExTXpNZ05URXlJRFV6TTNwdE1USTRMVEV4TW1FME9DQTBPQ0F3SURFZ01DQTVOaUF3SURRNElEUTRJREFnTVNBd0xUazJJREI2SWk4K0Nqd3ZjM1puUGc9PSJ9";

    function setUp() public {
        deployer = new DeployMoodNFT();
        moodNFT = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        // Act
        vm.prank(USER);
        moodNFT.mintNFT();
        console.log(moodNFT.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        // Act
        vm.prank(USER);
        moodNFT.mintNFT();
        vm.prank(USER);
        moodNFT.flipMood(0);

        // Assert
        assert(keccak256(abi.encodePacked(moodNFT.tokenURI(0))) == keccak256(abi.encodePacked(SAD_MOOD_SVG_URI)));
    }

    function testFlipTokenToHappy() public {
        // Act
        vm.prank(USER);
        moodNFT.mintNFT();
        vm.prank(USER);
        moodNFT.flipMood(0);
    }
    function testCanMintAndHaveABalance() public {
        // Arrange
        vm.prank(USER);

        // Act
        moodNFT.mintNFT();

        // Assert
        assertEq(moodNFT.balanceOf(USER), 1);
    }

    function testInitialMoodIsHappy() public {
        // Arrange
        vm.prank(USER);
        // Act
        moodNFT.mintNFT();
        console.log(moodNFT.tokenURI(0));
        console.log(HAPPY_MOOD_SVG_URI);

        // Assert
        assert(keccak256(abi.encodePacked(moodNFT.tokenURI(0))) == keccak256(abi.encodePacked(HAPPY_MOOD_SVG_URI)));
    }

    function testOnlyOwnerCanFlipMood() public {
        // Arrange
        vm.prank(USER);
        moodNFT.mintNFT();
        address ANOTHER_USER = makeAddr("another_user");
        
        // Act / Assert
        vm.prank(ANOTHER_USER);
        vm.expectRevert();
        moodNFT.flipMood(1);
    }


}
