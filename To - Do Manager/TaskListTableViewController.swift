//
//  TaskListTableViewController.swift
//  To - Do Manager
//
//  Created by Gastronom on 18.04.24.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    // Tasks Storage
    var tasksStorage: TasksStorageProtocol = TasksStorage() // contains func load and save tasks
    
    // Tasks Collection
    var tasks: [TaskPriority: [TaskProtocol]] = [:] {
        didSet {
            for (tasksGroupPriority, tasksGroup) in tasks {
                tasks[tasksGroupPriority] = tasksGroup.sorted{ task1, task2 in
                    let task1position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1position < task2position
                }
            }
        }
    }
    
    // Order of sections about type. Index in array corresponds index in table
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    
    // Order of presenting tasks about their status
    var taskStatusPosition: [TaskStatus] = [.planned, .copmleted]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Loding tasks
        loadTasks()
        //Editing activation button
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    // Func sorts tasks
    private func loadTasks() {
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        tasksStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    // Number of section in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    // Number of rows in certain section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Determine priority of task current section
       let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        
        return currentTasksType.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredTaskCell_stack(for: indexPath)
    }
    
    // The cell based on constraints
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        
        //Loadind cell's prototype with ID "taskCellConstraints"
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        
        // Getting task value, that wiil be presented in the cell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        // Text mark of the cymbol
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        // Changing symbol in cell
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        // Changing text in cell
        textLabel?.text = currentTask.title
        
        // Changing text and symbol color
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }

        return cell
    }
    
    // Return symbol for certain task's type
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .copmleted {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String?
        
        let tasksType = sectionsTypesPosition[section]
        if tasksType == .important {
            title = "Important"
        } else if tasksType == .normal {
            title = "Normal"
        }
        return title
    }
    
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        
        //Loadind cell's prototype with ID "taskCellStack"
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack") as! TaskCell
        
        // Getting task value that will be presented in cell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        // Changing text in cell
        cell.title.text = currentTask.title
        // Changing symble in cell
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        // Changing text color
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        
        return cell
    }
    
    // Changing tasks status as complited
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check if the task exists
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        // Make sure the task is'nt completed
        guard tasks[taskType]![indexPath.row].status == .planned else {
            // deselect of the cell
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        // Mark the task as completed
        tasks[taskType]![indexPath.row].status = .copmleted
        // Reload table section
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    //Changing task status as planned
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]? [indexPath.row] else {
            return nil
        }
        
        // Check if task is completed
        guard tasks[taskType]![indexPath.row].status == .copmleted else {
            return nil
        }
        
        // Create an action for changing current status
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Not completed") { _, _, _ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    // Deleting tasks
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete task
        let taskType = sectionsTypesPosition[indexPath.section]
        tasks[taskType]?.remove(at: indexPath.row)
        
        // Delete row of task
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Tasks sorting by hand
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Moving from section
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        // Moving to section
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        // Delete the task from the place from whitch it was moved
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        
        // Insert the task to new place
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        
        // If section has changed, change the task type according to new position
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        tableView.reloadData()
        
    }
    
}
