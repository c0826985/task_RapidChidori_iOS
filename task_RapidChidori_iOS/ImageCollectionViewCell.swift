//
//  ImageCollectionViewCell.swift
//  task_RapidChidori_iOS
//
//  Created by Shubham Behal on 23/01/22.
//

import UIKit

//child cell for horizontal images list
class ImageCollectionViewCell: UICollectionViewCell, ReusableViewNibLoading {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
