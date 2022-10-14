const {ethers: etherjs} = ethers;
import getContract from "./utils/getContract.js";


//let addr = "0xEB7A41D324ee4859E3cbFAd4b3820B82FCCe6658"
let addr = document.getElementById("address");
let getAddress = document.getElementById("get-addr");


getAddress.addEventListener("click", async function(e){
  e.preventDefault()
  const added = await getTodoList(addr.value);
  //console.log(addr.value, added);
  added.forEach((item) => {
    todos.innerHTML += `   
    <li class='my-2'>${item.task}</li>
    <li class= 'my-2'>${item.completed}</li> `;
    
  });
} )


async function getTodoList(addr) {
    const contract = getContract(true);
    try {
         const res = await contract.getTask(addr);
         console.log(res, "our result")
         const formatted = res.map((item) => {
            return {
              task: item[0],
              completed: item[1],
            };
          });
          return formatted;
        } catch (error) {
          console.log("error", error);
    }
} 


//-----------------------------------------------------------------------//
//createTask
let description = document.getElementById("_description");
let add = document.getElementById("add");

async function createTask(description) {
    const contract = await getContract(true); 
    try{
    const tnx = await contract.addTask(description);
   // const result = await tnx.wait();
    console.log(tnx, "result-----------------");
    return tnx
    } catch (error){
    }
}

add.addEventListener("click", async function(e){
    e.preventDefault()
    const added = await createTask(description.value);
    console.log(description.value, added);
  } )



  //-------------------------------------------------------//
//removeTask
async function removeTask() {
    const contract = await getContract(true);
    try{
      const result = await contract.removeTask( 2,theAddress);
      console.log(result, "result-----------------")
    } catch (error){

    }
}
//removeTask();

//completeTask
async function completeTask() {
    const contract = await getContract(true);
    const result = await contract.completeTask(1, theAddress);
    console.log(result, "result-----------------")
}
//completeTask();

//updateTask
async function updateTask() {
//     const contract = await getContract(true);
//     const result = await contract.updateTask(1, "code");
    const contract = await getTodoList();
    console.log(result, "result-----------------")
    data.forEach((item) => {
        todos.innerHTML += `   
        <li class='my-2'>${item.description}</li>`;
      });
}
// updateTask();


  
  