//
//  TaskCell.swift
//  To - Do Manager
//
//  Created by Gastronom on 19.04.24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
