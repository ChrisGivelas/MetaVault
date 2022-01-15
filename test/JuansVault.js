const { expect } = require('chai');

describe('JuansVault contract', function () {
    let JuansVault;
    let hardhatJuansVault;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        JuansVault = await ethers.getContractFactory('JuansVault');
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // for it to be deployed(), which happens onces its transaction has been
        // mined.
        hardhatJuansVault = await JuansVault.deploy();

        // We can interact with the contract by calling `hardhatToken.method()`
        await hardhatJuansVault.deployed();
    });

    describe('Deployment', function () {
        // `it` is another Mocha function. This is the one you use to define your
        // tests. It receives the test name, and a callback function.

        // If the callback function is async, Mocha will `await` it.
        it('Should set the right owner', async function () {
            // Expect receives a value, and wraps it in an assertion objet. These
            // objects have a lot of utility methods to assert values.

            // This test expects the owner variable stored in the contract to be equal
            // to our Signer's owner.
            expect(await hardhatJuansVault.owner()).to.equal(owner.address);
        });
    });
});