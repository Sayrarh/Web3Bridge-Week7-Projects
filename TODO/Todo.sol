//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TodoList{
    struct Todo{
        string task;
        bool completed;
    }

    uint ID = 1;
    mapping(uint => Todo[]) _Todo;

    event TaskAdded(uint ID,
        string task,
        bool completed);
    
    event TaskCompleted(uint ID, 
        bool completed);

    //function to add todo
    function addTask(string memory _task) external{
        _Todo[ID].push(Todo({
            task:_task,
            completed:false
        }));
        emit TaskAdded(ID, _task, false);
    }

    //function to update todo
    function updateTask(string memory _task, uint taskid) public{
        Todo storage td = _Todo[ID][taskid];
        td.task = _task;
    }

    //function to return todo
    function getTask() public view returns(Todo[] memory){
        Todo[] storage td = _Todo[ID];
        return td;
    }

    //function to checktask
    function checkTask(uint taskID) public{
        Todo memory td = _Todo[ID][taskID];
         td.completed = true;
         emit TaskCompleted(ID, true);
    }

    //function to remove task
    function removeTask(uint taskID) public view {
         Todo memory td = _Todo[ID][taskID];
         delete td;
    }


}