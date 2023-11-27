const Moralis = require("moralis").default;
const { EvmChain } = require("@moralisweb3/common-evm-utils");

const runApp = async (a) => {
  await Moralis.start({
    apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjM5NDg2ZGEzLTJhMTYtNDY1Ny1hOWI4LTZiOTVhODJjMjg1ZSIsIm9yZ0lkIjoiMzY1NzkyIiwidXNlcklkIjoiMzc1OTM5IiwidHlwZUlkIjoiYjA4NmZjMDMtNDgyNi00MjMxLTg1NjEtZTE1NTM0NTc0NzAxIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MDA5NDIzNjgsImV4cCI6NDg1NjcwMjM2OH0.1gCGLlqgTkWLDI4hBveJAvZp3vRzdNRRfHScPdNXycM",

  });

  const address=a;
  const chain = EvmChain.MUMBAI;

  const tokenId = "0";

  const response = await Moralis.EvmApi.nft.getNFTMetadata({
    address,
    chain,
    tokenId,
  });

  const meta=response.toJSON().metadata;
  const val=JSON.parse(meta);
//   console.log(val.image);
 const val1=val.image
  return JSON.stringify(val1);

  
  
};

const address="0x11A6d38c60e017AEd476E957c1af1a4C5cA02F88";

const img= runApp(address);




const fs = require('fs');

const appendToJson = (filename, key, value) => {
  // Check if the file exists
  if (fs.existsSync(filename)) {
    // Read the existing JSON data
    const jsonData = fs.readFileSync(filename, 'utf-8');
    const data = JSON.parse(jsonData);

    // Append the new key-value pair
    data[key] = value;

    // Write the updated data back to the file
    fs.writeFileSync(filename, JSON.stringify(data, null, 2));
    console.log(`Key '${key}' with value '${value}' appended to ${filename}`);
  } else {
    // If the file doesn't exist, create a new one with the provided key-value pair
    const data = { [key]: value };
    fs.writeFileSync(filename, JSON.stringify(data, null, 2));
    console.log(`File ${filename} created with key '${key}' and value '${value}'`);
  }
};


const filename = 'SVG_holder.json';

img.then((value)=>{
  appendToJson(filename, address, value)
  // console.log(value);
})