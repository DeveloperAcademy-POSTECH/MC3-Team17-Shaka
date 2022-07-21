//
//  MapModalController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/20.
//

import UIKit

class MapModalController: UIViewController {
    
    @IBOutlet weak var circularImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImage.layer.masksToBounds = true
        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
    }
}
