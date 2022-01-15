const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('MetaVault contract', () => {
    let initialBalance;
    let USDC;
    let hardhatUSDC;
    let WETH;
    let hardhatWETH;
    let metavault;
    let hardhatMetavault;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        USDC = await ethers.getContractFactory('USDC')
        WETH = await ethers.getContractFactory('WETH')
        metavault = await ethers.getContractFactory('MetaVault')

        initialBalance = 1000000;

        hardhatUSDC = await USDC.deploy(initialBalance);
        hardhatWETH = await WETH.deploy(initialBalance);
        hardhatMetavault = await metavault.deploy();

        await hardhatUSDC.deployed();
        await hardhatWETH.deployed();
        await hardhatMetavault.deployed();
    });

    describe('create vault', () => {
        it('should have the right owner', async () => {
            console.log('yyyy')
            let vault = await hardhatMetavault.createVault(1)
            console.log('xxxx')
            expect(await vault.owner()).to.equal(owner.address)
        })
    })
})
