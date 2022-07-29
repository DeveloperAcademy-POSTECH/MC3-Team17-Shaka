//
//  ViewController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var surfImage: UIImageView!
    @IBOutlet weak var cardBackground: UIView!
    @IBOutlet weak var getWaterButton: UIView!
    @IBOutlet weak var outWaterButton: UIView!
    @IBOutlet weak var goSurfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surfImage.layer.cornerRadius = 10
        goSurfView.layer.cornerRadius = 10
        goSurfView.layer.cornerRadius = 10
        
        goSurfView.layer.shadowOffset = CGSize(width: 1, height: 1)
        goSurfView.layer.shadowOpacity = 0.2
        goSurfView.layer.shadowRadius = 10
        
        cardBackground.layer.cornerRadius = 10
        
        getWaterButton.layer.cornerRadius = 10
        getWaterButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        getWaterButton.layer.shadowOpacity = 0.2
        getWaterButton.layer.shadowRadius = 10
        getWaterButton.isUserInteractionEnabled = true
        getWaterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getWaterTapped(_:))))
        
        outWaterButton.layer.cornerRadius = 10
        outWaterButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        outWaterButton.layer.shadowOpacity = 0.2
        outWaterButton.layer.shadowRadius = 10
        outWaterButton.isUserInteractionEnabled = true
        outWaterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outWaterTapped(_:))))
    }
    
    @objc func getWaterTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://boat.kcg.go.kr/home/wtrlsrActInfo/weathrSpcnwsDclr/infoView1.do") else {
            return
        }
        let webVC = WebViewController(url: url, title: "입수 신고")
        let navVC = UINavigationController(rootViewController: webVC)
        present(navVC, animated: true)
    }
    
    @objc func outWaterTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://boat.kcg.go.kr/home/common/cert_info.do") else {
            return
        }
        let webVC = WebViewController(url: url, title: "입수 신고")
        let navVC = UINavigationController(rootViewController: webVC)
        present(navVC, animated: true)
    }
}
