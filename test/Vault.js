const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Vault contract', function () {
    let initialBalance;
    let USDC;
    let hardhatUSDC;
    let WETH;
    let hardhatWETH;
    let vault;
    let hardhatVault;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        USDC = await ethers.getContractFactory('USDC');
        WETH = await ethers.getContractFactory('WETH');
        vault = await ethers.getContractFactory('Vault');

        initialBalance = 1000000;

        hardhatUSDC = await USDC.deploy(initialBalance);
        hardhatWETH = await WETH.deploy(initialBalance);
        hardhatVault = await vault.deploy(owner.address, 1);

        await hardhatUSDC.deployed();
        await hardhatWETH.deployed();
        await hardhatVault.deployed();
    });

    describe('Deployment', function () {
        it('owner should have a balance of 1,000,000 USDC', async function () {
            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(initialBalance);
        });

        it('owner should have a balance of 1,000,000 WETH', async function () {
            expect(await hardhatWETH.balanceOf(owner.address)).to.equal(initialBalance);
        });

        it('Should set the right owner', async function () {
            expect(await hardhatVault.owner()).to.equal(owner.address);
        });
    });

    describe('Transactions', () => {
        it('deposit 10 USDC & 10 WETH to vault', async () => {
            transferAmount = 10;

            await hardhatUSDC.approve(hardhatVault.address, transferAmount);
            await hardhatVault.deposit(hardhatUSDC.address, transferAmount);

            await hardhatWETH.approve(hardhatVault.address, transferAmount);
            await hardhatVault.deposit(hardhatWETH.address, transferAmount);

            let remainingBalance = initialBalance - transferAmount;

            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(remainingBalance);
            expect(await hardhatUSDC.balanceOf(hardhatVault.address)).to.equal(transferAmount);

            expect(await hardhatWETH.balanceOf(owner.address)).to.equal(remainingBalance);
            expect(await hardhatWETH.balanceOf(hardhatVault.address)).to.equal(transferAmount);
        });
    });
});