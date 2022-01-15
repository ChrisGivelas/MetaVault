const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Vault contract', function () {
    let initialBalance;
    let USDC;
    let hardhatUSDC;
    let vault;
    let hardhatVault;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        USDC = await ethers.getContractFactory('USDC');
        vault = await ethers.getContractFactory('Vault');
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        initialBalance = 1000000;

        hardhatUSDC = await USDC.deploy(initialBalance);
        hardhatVault = await vault.deploy();

        await hardhatUSDC.deployed();
        await hardhatVault.deployed();
    });

    describe('Deployment', function () {
        it('owner should have a balance of 1,000,000 USDC', async function () {
            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(initialBalance);
        });

        it('Should set the right owner', async function () {
            expect(await hardhatVault.owner()).to.equal(owner.address);
        });
    });

    describe('Transactions', () => {
        it('deposit 10 USDC to vault', async () => {
            transferAmount = 10;

            await hardhatUSDC.approve(hardhatVault.address, transferAmount);
            await hardhatVault.deposit(hardhatUSDC.address, transferAmount);

            let remainingBalance = initialBalance - transferAmount;

            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(remainingBalance);
            expect(await hardhatUSDC.balanceOf(hardhatVault.address)).to.equal(transferAmount);
        });
    });
});