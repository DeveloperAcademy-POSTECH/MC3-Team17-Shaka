//
//  CustomUserProfileImage.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/21.
//

import UIKit

class CustomUserProfileImage: UIImage {
    override func awakeFromNib() {
        super.awakeFromNib()
        UIImage.layer.masksToBounds = true
        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
    }
}
