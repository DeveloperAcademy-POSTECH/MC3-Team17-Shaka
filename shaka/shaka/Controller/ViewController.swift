//
//  ViewController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWaterTapped(_ sender: Any) {
        guard let url = URL(string: "https://boat.kcg.go.kr/home/wtrlsrActInfo/weathrSpcnwsDclr/infoView1.do") else {
            return
        }
        let webVC = WebViewController(url: url, title: "입수 신고")
        let navVC = UINavigationController(rootViewController: webVC)
        present(navVC, animated: true)
    }
    
    @IBAction func offWaterTapped(_ sender: Any) {
        guard let url = URL(string: "https://boat.kcg.go.kr/home/common/cert_info.do") else {
            return
        }
        let webVC = WebViewController(url: url, title: "퇴수 신고")
        let navVC = UINavigationController(rootViewController: webVC)
        present(navVC, animated: true)
    }
    
}
