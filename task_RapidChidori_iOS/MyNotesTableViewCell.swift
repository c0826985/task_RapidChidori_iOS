//
//  MyNotesTableViewCell.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 20/01/22.
//

import UIKit

class MyNotesTableViewCell: UITableViewCell,ReusableViewNibLoading {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = "my first note"
        descriptionLbl.text = "my note description"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
