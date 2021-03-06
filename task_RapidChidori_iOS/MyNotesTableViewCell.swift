//
//  MyNotesTableViewCell.swift
//  task_RapidChidori_iOS
//
//  Created by Shubham Behal on 20/01/22.
//

import UIKit

//child view of notes shown on the main screen
class MyNotesTableViewCell: UITableViewCell,ReusableViewNibLoading {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = "my first note"
        descriptionLbl.text = "my note description"
        dateLbl.text = "note date"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
