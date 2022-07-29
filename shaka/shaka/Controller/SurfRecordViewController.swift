//
//  SurfRecordViewController.swift
//  shaka
//
//  Created by 유정인 on 2022/07/29.
//

import UIKit

class SurfRecordViewController: UIViewController {
    
    weak override var parent: UIViewController? { get }
    
    @IBOutlet weak var surfRecordView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var standingTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surfRecordView.layer.cornerRadius = 10
        
        surfRecordView.layer.shadowOffset = CGSize(width: 1, height: 1)
        surfRecordView.layer.shadowOpacity = 0.2
        surfRecordView.layer.shadowRadius = 10
    }
}
