//
//  TaskEditController.swift
//  To - Do Manager
//
//  Created by Gastronom on 21.04.24.
//

import UIKit

class TaskEditController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var taskStatusSwitch: UISwitch!
    
    // Name of tasks types
    private var taskTitles: [TaskPriority:String] = [
        .important : "Important",
        .normal : "Normal"
    ]
    
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitle?.text = taskText
        // Upadating tag according to current type
        taskTypeLabel?.text = taskTitles[taskType]
        
        // Updating task status
        if taskStatus == .copmleted {
            taskStatusSwitch.isOn = true
        }
 
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        // Getrting current values
        let title = taskTitle?.text ?? ""
        let type  = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .copmleted : .planned
        
        if title.trimmingCharacters(in: .whitespaces).count == 0 {
            
            AlertHelper.showAlert( in: self, title: "Hm...", message: "Please write your task")
            
        } else {
            
            // Call handler
            doAfterEdit?(title, type, status)
            
            // Transition to previous screen
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            let destination = segue.destination as! TaskTypeController
            
            destination.selectedType = taskType
            
            destination.doAfterTypeSlected = { [ unowned self ] selectedType in
                taskType = selectedType
                // Updating label with current type
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }
}
