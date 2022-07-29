//
//  SurfRecordViewController.swift
//  shaka
//
//  Created by 유정인 on 2022/07/28.
//

import UIKit

class SurfRecordViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var surfGraphCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dateCell = surfGraphCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SurfDateCollectionViewCell else { return UICollectionViewCell() }
        dateCell.configure(with: dataSource[indexPath.item].date)
        dateCell.backgroundColor = dataSource[indexPath.item].degreeOfStand.cellBackground
        if indexPath.item == dataSource.count-1 {
            dateCell.isSelected = true
        }
        return dateCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(dataSource[indexPath.item])
//    }
}
