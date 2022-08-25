//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title TODO contract 
/// @author Oluwatosin Serah Ajao

contract TodoList{
    struct Todo{
        string task;
        bool completed;
    }

    mapping(address => Todo[]) _Todo;

    event TaskAdded(address caller,
        string task,
        bool completed);
    
    event TaskCompleted(uint ID, 
        bool completed);

    //function to add todo
    function addTask(string memory _task) external{
        _Todo[msg.sender].push(Todo({
            task:_task,
            completed:false
        }));
        emit TaskAdded(msg.sender, _task, false);
    }

    //function to update todo
    function updateTask(string memory _task, uint taskID) external{
        Todo storage td = _Todo[msg.sender][taskID];
        td.task = _task;
    }

    //function to return all tasks
    function getTask() public view returns(Todo[] memory){
        Todo[] storage td = _Todo[msg.sender];
        return td;
    }

    //function to checktask
    function completeTask(uint taskID) external{
      Todo storage td = _Todo[msg.sender][taskID];
      td.completed = true;
         emit TaskCompleted(taskID, true);
    }

    //function to remove task
    function removeTask(uint taskID) external view{
         Todo memory td = _Todo[msg.sender][taskID];
         delete td;
    }


}