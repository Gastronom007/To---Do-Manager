//
//  TasksStorage.swift
//  To - Do Manager
//
//  Created by Gastronom on 18.04.24.
//

import Foundation

protocol TasksStorageProtocol {
    
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

class TasksStorage: TasksStorageProtocol {
    
    func loadTasks() -> [TaskProtocol] {
        let testTasks: [TaskProtocol] = [
            Task(title: "Sell may old MacBook", type: .normal, status: .planned),
            Task(title: "Learn new framework", type: .important, status: .planned),
            Task(title: "Pay the bills", type: .important, status: .copmleted),
            Task(title: "Buy a new vacuum", type: .normal, status: .copmleted),
            Task(title: "Rewrite my CV", type: .important, status: .planned),
            Task(title: "Change job", type: .important, status: .planned),
            Task(title: "Make important changes in my life like: cahnge job, buy a house, star a family,  be happy and successful", type: .important, status: .planned)
        ]
        return testTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        
    }
    
    
}
