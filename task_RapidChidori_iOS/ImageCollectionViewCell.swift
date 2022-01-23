//
//  ImageCollectionViewCell.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 23/01/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, ReusableViewNibLoading {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
