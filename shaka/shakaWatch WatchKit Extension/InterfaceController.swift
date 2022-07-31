//
//  InterfaceController.swift
//  coremotionWatch WatchKit Extension
//
//  Created by Hyung Seo Han on 2022/07/31.
//

import WatchKit
import Foundation
import CoreMotion
import UIKit

class InterfaceController: WKInterfaceController {
    
    //    let manager = CMMotionManager()
    //    let motionManager = CMMotionActivityManager()
    
    // label from storyboard
    @IBOutlet var surfTimer: WKInterfaceLabel!
    @IBOutlet var standTimer: WKInterfaceLabel!
    
    // altimeter and timer
    var altimeter = CMAltimeter()
    var surfTime = Timer()
    var standTime = Timer()
    var deactiveTime = Timer()
    
    var surfTimerCounter = 0
    var standTimerCounter = 0
    var deactiveTimeCounter = 0
    
    var isSurfing: Bool = false
    var isCountingSurfing: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("Didappear")
        self.deactiveTime.invalidate()
        print(deactiveTimeCounter)

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        print("Deactivate")
        self.deactiveTimeCounter = 0
        self.deactiveTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(deactiveTimeCount), userInfo: nil, repeats: true)
        willActivate()
    }
//
//    override func willDisappear() {
//        print("Disappear")
//        test()
//    }
    
    func test() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData: CMAltitudeData?, _ error: Error?)in
                guard let altitudeData = altitudeData else { return }
                // 사용자 워치 높이 확인
                let altitude = round(altitudeData.relativeAltitude.doubleValue*100)/100
                
                // 손이 올라가있으면서 서핑중이라면
                if altitude>0.55 && self.isSurfing {
                    // 아직 스탠드 타임워치가 실행 안될때
                    if self.isCountingSurfing == false {
                        self.standTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.standTimeCount), userInfo: nil, repeats: true)
                        self.isCountingSurfing.toggle()
                        print("Stand activated. Start counting stand hour")
                    } else {
                        print("Stand activated. But the counter of stand is already started")
                    }
                } else if altitude<(0.3) {
                    print("Sit activated")
                    self.standTime.invalidate()
                    self.isCountingSurfing = false
                }
            })
        }
    }

    @IBAction func startButton() {
        test()
        isSurfing.toggle()
        surfTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(surfTimeCount), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopButton() {
        isSurfing.toggle()
        surfTime.invalidate()
    }
    
    @objc func surfTimeCount() {
        surfTimerCounter += 1
        surfTimer.setText(makeTimeLabelString(count: surfTimerCounter))
    }
    
    @objc func standTimeCount() {
        standTimerCounter += 1
        standTimer.setText(makeTimeLabelString(count: standTimerCounter))
    }
    
    @objc func deactiveTimeCount() {
        print("SHibal")
        deactiveTimeCounter += 1
    }
    
    func makeTimeLabelString(count: Int) -> String {
        var hours = String(count/3600)
        var minutes = String((count % 3600)/60)
        var seconds = String((count % 3600)%60)
        
        hours = (hours.count == 1 ? "0"+hours : hours)
        minutes = (minutes.count == 1 ? "0"+minutes : minutes)
        seconds = (seconds.count == 1 ? "0"+seconds : seconds)
        let timeLabelString = hours+" : "+minutes+" : "+seconds
        
        return timeLabelString
    }
}
