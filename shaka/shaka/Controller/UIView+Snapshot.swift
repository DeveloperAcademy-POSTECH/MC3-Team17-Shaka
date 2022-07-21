//
//  UIView+Snapshot.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/21.
//

import UIKit

extension UIView  {
    //뷰가 랜더링될때 뒷 배경을 캡쳐
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
      return renderer.image(actions: { rendererContext in
        layer.render(in: rendererContext.cgContext)
    })
  }
}
