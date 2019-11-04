//
//  TTCell.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 05/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit

class TTCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
