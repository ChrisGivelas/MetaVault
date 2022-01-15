const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('JuansVault contract', function () {
    let initialBalance;
    let USDC;
    let hardhatUSDC;
    let JuansVault;
    let hardhatJuansVault;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        USDC = await ethers.getContractFactory('USDC');
        JuansVault = await ethers.getContractFactory('JuansVault');
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        initialBalance = 1000000;

        hardhatUSDC = await USDC.deploy(initialBalance);
        hardhatJuansVault = await JuansVault.deploy();

        await hardhatUSDC.deployed();
        await hardhatJuansVault.deployed();
    });

    describe('Deployment', function () {
        it('owner should have a balance of 1,000,000 USDC', async function () {
            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(initialBalance);
        });

        it('Should set the right owner', async function () {
            expect(await hardhatJuansVault.owner()).to.equal(owner.address);
        });
    });

    describe('Transactions', () => {
        it('deposit 10 USDC to vault', async () => {
            transferAmount = 10;

            await hardhatUSDC.approve(hardhatJuansVault.address, transferAmount);
            await hardhatJuansVault.deposit(hardhatUSDC.address, transferAmount);

            let remainingBalance = initialBalance - transferAmount;

            expect(await hardhatUSDC.balanceOf(owner.address)).to.equal(remainingBalance);
            expect(await hardhatUSDC.balanceOf(hardhatJuansVault.address)).to.equal(transferAmount);
        });
    });
});