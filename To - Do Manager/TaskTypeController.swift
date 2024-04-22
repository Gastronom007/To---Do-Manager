//
//  TaskTypeController.swift
//  To - Do Manager
//
//  Created by Gastronom on 21.04.24.
//

import UIKit

class TaskTypeController: UITableViewController {
    
    // Handler of type selector
    var doAfterTypeSlected: ((TaskPriority) -> Void)?
    
    // Tuple describing tasks type
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    
    // Collection of available types of tasks with their description
    private var taskTypesInformation: [TypeCellDescription] = [
        (type: .important, title: "Important", description: "This type of tasks have the highest priority to execute. All important tasks are disaplayed at the very top of the thask list"),
        (type: .normal, title: "Normal", description: "Normal priority task")
    ]
    
    // Choosing priority
    var selectedType: TaskPriority = .normal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting UINib
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        // Register custom cell in tableView
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTypesInformation.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        
        // Getting current item to display in the row
        let typeDescription = taskTypesInformation[indexPath.row]
        
        // Filling cell with data
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        
        // If type is selected, checkmark
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Getting selected type
        let selectedType = taskTypesInformation[indexPath.row].type
        
        // Call handler
        doAfterTypeSlected?(selectedType)
        
        // Transition to previous screen
        navigationController?.popViewController(animated: true)
    }
}
