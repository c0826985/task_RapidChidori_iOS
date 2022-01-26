//
//  PoppverController.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 26/01/22.
//

import UIKit

class PoppverController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (image != nil) {
            imageView.image = image
        }
    }
    @IBAction func tapoutside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
