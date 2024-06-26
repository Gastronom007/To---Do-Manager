//
//  Task.swift
//  To - Do Manager
//
//  Created by Gastronom on 18.04.24.
//

import Foundation


enum TaskPriority: String {
    
    case normal
    case important
}


enum TaskStatus: Int {
    
    case planned
    case copmleted
}

protocol TaskProtocol {
    
    var title: String { get set }
    
    var type: TaskPriority { get set }
    
    var status: TaskStatus { get set }
}


struct Task: TaskProtocol {
    
    var title: String
    var type: TaskPriority
    var status: TaskStatus
    
    
}
