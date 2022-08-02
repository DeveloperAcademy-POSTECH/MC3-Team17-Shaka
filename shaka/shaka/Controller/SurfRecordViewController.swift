//
//  SurfRecordViewController.swift
//  shaka
//
//  Created by 유정인 on 2022/07/28.
//

import UIKit

class SurfRecordViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var showSurfRecordView: UIView!
    @IBOutlet weak var surfGraphCV: UICollectionView!
    @IBOutlet weak var surfDateLabel: UILabel!
    @IBOutlet weak var whenSurfLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var standingTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSurfRecordView.layer.cornerRadius = 10
        self.showSurfRecordView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.showSurfRecordView.layer.shadowOpacity = 0.2
        self.showSurfRecordView.layer.shadowRadius = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dateCell = surfGraphCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SurfDateCollectionViewCell else { return UICollectionViewCell() }
        dateCell.configure(with: dataSource[indexPath.item].date)
        dateCell.backgroundColor = dataSource[indexPath.item].degreeOfStand.cellBackground
        dateCell.layer.cornerRadius = 2
        if indexPath.item == dataSource.count-1 {
            dateCell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        }
        if dataSource[indexPath.item].degreeOfStand == .low {
            dateCell.dateLabel.textColor = .black
        }
        return dateCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = dataSource[indexPath.item].date
        self.surfDateLabel.text = date.replacingOccurrences(of: "/", with: "월 ") + "일"
        self.whenSurfLabel.text = dataSource[indexPath.item].time
        self.totalTimeLabel.text = dataSource[indexPath.item].totalSecond
        self.standingTimeLabel.text = dataSource[indexPath.item].standSecond
    }
}
