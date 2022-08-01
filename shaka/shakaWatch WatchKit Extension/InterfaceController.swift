//
//  InterfaceController.swift
//  coremotionWatch WatchKit Extension
//
//  Created by Hyung Seo Han on 2022/07/31.
//

import WatchKit
import WatchConnectivity
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
        configureWCSession()
        print("awake")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("Didappear")
        self.deactiveTime.invalidate()
        configureWCSession()
        print(deactiveTimeCounter)
        
    }
    
    func configureWCSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        } else {
            print("연결 실패")
        }
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
    
    func detectingStandStatus() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData: CMAltitudeData?, _ error: Error?)in
                guard let altitudeData = altitudeData else { return }
                // 사용자 워치 높이 확인
                let altitude = round(altitudeData.relativeAltitude.doubleValue*100)/100
                
                // 손이 올라가있으면서 서핑중이라면
                if altitude > 0.55 && self.isSurfing {
                    // 아직 스탠드 타임워치가 실행 안될때
                    if self.isCountingSurfing == false {
                        self.standTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.standTimeCount), userInfo: nil, repeats: true)
                        self.isCountingSurfing.toggle()
                        print("Stand activated. Start counting stand hour")
                    } else {
                        print("Stand activated. But the counter of stand is already started")
                    }
                } else if altitude < (0.3) {
                    print("Sit activated")
                    self.standTime.invalidate()
                    self.isCountingSurfing = false
                }
            })
        }
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
        sendMessageToiOS(message: "00 : 00 : 00")
    }
    
    func sendMessageToiOS(message: String) {
        let messageToSend = ["Value": message, "Count": self.surfTimerCounter, "Check": isSurfing] as [String: Any]
        WCSession.default.sendMessage(messageToSend, replyHandler: { _ in
            print("전송 성공")
        }, errorHandler: {error in
            print(error.localizedDescription)
        })
    }
    
    @objc func surfTimeCount() {
        surfTimerCounter += 1
        let timeString = makeTimeLabelString(count: surfTimerCounter)
        surfTimer.setText(timeString)
        sendMessageToiOS(message: timeString)
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
        var hours = String(count / 3600)
        var minutes = String((count % 3600) / 60)
        var seconds = String((count % 3600) % 60)
        
        hours = (hours.count == 1 ? "0" + hours : hours)
        minutes = (minutes.count == 1 ? "0" + minutes : minutes)
        seconds = (seconds.count == 1 ? "0" + seconds : seconds)
        let timeLabelString = hours + " : " + minutes + " : " + seconds
        
        return timeLabelString
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print(activationState)
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
//        print(message)
        let value = message["Value"] as? String
        let receiceCount = message["Count"] as? Int
        let surfing = message["Check"] as? Bool
        DispatchQueue.main.async {
            self.surfTimer.setText(value)
            self.surfTimerCounter = receiceCount ?? 0
            self.isSurfing = surfing ?? false
            self.startButton()
        }
    }
    
}
