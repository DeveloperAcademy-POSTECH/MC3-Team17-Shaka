//
//  TimerViewController.swift
//  shaka
//
//  Created by 최윤석 on 2022/07/27.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timeCircle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircle()
    }
    
    func makeCircle() {
        timeCircle.layer.cornerRadius = timeCircle.layer.bounds.width / 2
        timeCircle.clipsToBounds = true
        timeCircle.layer.borderWidth = 15
        timeCircle.layer.borderColor = UIColor.gray.cgColor
    }
}
