//
//  MapSampleController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/21.
//

import UIKit

class MapSampleController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pinnedIconTapped(_ sender: Any) {
        guard let mapModalVC = storyboard?.instantiateViewController(withIdentifier: "MapModalController")
         as? MapModalController else {
             assertionFailure("No view controller ID ReactionViewController in storyboard")
             return
         }
         
         // set the modal presentation to full screen, in iOS 13, its no longer full screen by default
         mapModalVC.modalPresentationStyle = .fullScreen
         
         // present the view controller modally without animation
         self.present(mapModalVC, animated: false, completion: nil)
    }
}
