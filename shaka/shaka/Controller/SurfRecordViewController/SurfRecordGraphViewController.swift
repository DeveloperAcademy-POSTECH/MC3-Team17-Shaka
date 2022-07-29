//
//  SurfRecordGraphViewController.swift
//  shaka
//
//  Created by 유정인 on 2022/07/28.
//

import UIKit

class SurfRecordGraphViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let dataSource: [String] = ["6/26", "6/27", "6/28", "6/29", "6/30", "7/1", "7/2", "7/3", "7/4", "7/5", "7/6", "7/7", "7/8", "7/9", "7/10", "7/11", "7/12", "7/13", "7/14", "7/15", "7/16", "7/17", "7/18", "7/19", "7/20", "7/21", "7/22", "7/23", "7/24", "7/25", "7/26", "7/27", "7/28", "7/29", "7/30"]
    
    @IBOutlet weak var surfGraphCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let dateCell = surfGraphCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SurfDateCollectionViewCell {
            dateCell.configure(with: dataSource[indexPath.item])
            cell = dateCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Date: \(dataSource[indexPath.row])")
    }
}
