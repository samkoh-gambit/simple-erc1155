async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const Contract = await ethers.getContractFactory("MyERC1155Token");
    const contract = await Contract.deploy();

    await contract.waitForDeployment(); 

    console.log("Contract deployed to:", contract.target); 
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  