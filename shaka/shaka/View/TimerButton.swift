//
//  StartButton.swift
//  shaka
//
//  Created by 최윤석 on 2022/07/28.
//

import UIKit

class TimerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConfig()
    }
    
    func setConfig() {
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 10
    }
    
    func touchIn() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: { self.transform = .init(scaleX: 0.8, y: 0.8) }, completion: nil)
    }
    
    func touchOut() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: { self.transform = .identity }, completion: nil)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchOut()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchIn()
    }
}
