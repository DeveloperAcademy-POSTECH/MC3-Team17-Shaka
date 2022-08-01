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
    @IBOutlet var startButtonLabel: WKInterfaceButton!

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
        setNotifications()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        // deactive의 상태로 들어가기 직전 타임스탬프를 찍어서 UserDefault 값으로 설정함
        // 해당값의 접근 가능하는 방법은 forKey에 적혀져 있는 문자열로 접근 가능
        UserDefaults.standard.setValue(Date(), forKey: "deactiveStartedStamp")
        
        surfTime.invalidate()
        // 인식할 Notification의 네이밍 설정
        Foundation.NotificationCenter.default.post(name: NSNotification.Name("deactivated"), object: nil)
    }
    
    func detectingStandStatus() {
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
    
    // 각각 알림에 대한 옵저버 선언
    func setNotifications() {
        Foundation.NotificationCenter.default.addObserver(self, selector: #selector(printDeactivation), name: NSNotification.Name("deactivated"), object: nil)
        Foundation.NotificationCenter.default.addObserver(self, selector: #selector(printBackgroundTime(_:)), name: NSNotification.Name("applicationDidBecomeActive"), object: nil)
    }
    
    @IBAction func startButton() {
        if isSurfing {
            isSurfing = false
            surfTime.invalidate()
            startButtonLabel.setTitle("Start")
        } else {
            detectingStandStatus()
            isSurfing = true
            surfTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(surfTimeCount), userInfo: nil, repeats: true)
            startButtonLabel.setTitle("Pause")
        }
    }
    
    @IBAction func stopButton() {
        isSurfing = false
        surfTime.invalidate()
        surfTimer.setText("00 : 00 : 00")
        startButtonLabel.setTitle("Start")
        surfTimerCounter = 0
        standTimerCounter = 0
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
        deactiveTimeCounter += 1
    }
    
    @objc func printBackgroundTime(_ notification: Notification) {
        if isSurfing {
            let time = notification.userInfo?["time"] as? Int ?? 0
            surfTimerCounter += time
            surfTimer.setText(makeTimeLabelString(count: surfTimerCounter))
            surfTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(surfTimeCount), userInfo: nil, repeats: true)
        } else {
            print("Ya ho~")
        }
    }
    
    @objc func printDeactivation() {
        print("Deactivated")
    }
}
