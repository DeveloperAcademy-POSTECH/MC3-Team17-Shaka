//
//  WeatherTVC.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/29.
//

import UIKit

class WeatherTVC: UITableViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherTitleView: UILabel!
    @IBOutlet weak var weatherInfoView: UILabel!
    @IBOutlet weak var weatherTimeView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
