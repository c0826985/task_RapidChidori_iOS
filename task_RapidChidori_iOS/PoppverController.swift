//
//  PoppverController.swift
//  task_RapidChidori_iOS
//
//  Created by Shubham Behal on 26/01/22.
//

import UIKit

//This controller is responsible to show images in a zoomed state

class PoppverController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (image != nil) {
            imageView.image = image
        }
    }
    
    //close image on tap outside its boundary
    @IBAction func tapoutside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
