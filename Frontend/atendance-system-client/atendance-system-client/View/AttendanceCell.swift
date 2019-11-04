//
//  AttendanceCell.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 07/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {
    
    @IBOutlet weak var subjectName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
