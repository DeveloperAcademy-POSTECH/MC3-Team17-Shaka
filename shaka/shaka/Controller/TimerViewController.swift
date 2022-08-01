//
//  TimerViewController.swift
//  shaka
//
//  Created by 최윤석 on 2022/07/27.
//

import UIKit
import WatchConnectivity

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timeCircle: UIView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var standingTimeLabel: UILabel!
    @IBOutlet weak var startButtonLabel: UIButton!
    
    var totalTimer = Timer()
    var standingTimer = Timer()
    var totalCount = 0
    var standingCount = 0
    var isSurfing = false
    var timeResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWCSession()
        makeCircle()
    }
    
    func configureWCSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        } else {
            print("연결 실패")
        }
    }
    
    // 타이머 시작, 일시정지 버튼
    @IBAction func startPauseAction(_ sender: UIButton) {
        if isSurfing {
            isSurfing = false
            totalTimer.invalidate()
            startButtonLabel.setTitle("시작", for: .normal)
            startButtonLabel.backgroundColor = UIColor(named: "StartButtonColor")
        } else {
            isSurfing = true
            startButtonLabel.setTitle("일시정지", for: .normal)
            startButtonLabel.backgroundColor = .gray
            totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCount), userInfo: nil, repeats: true)
        }
    }
    // 정지 버튼
    @IBAction func stopAction(_ sender: UIButton) {
        // 타이머가 돌아가고 있는 상태에서 정지를 누를 시 일시정지 표시를 시작으로 변경
        if startButtonLabel.currentTitle == "일시정지" {
            startButtonLabel.setTitle("시작", for: .normal)
            startButtonLabel.backgroundColor = UIColor(named: "StartButtonColor")
        }
        totalTimer.invalidate()
        totalTimeLabel.text = "00 : 00 : 00"
        let time = secondsToMinutes(seconds: totalCount)
        let timeString = makeTimeToText(hours: time[0], minutes: time[1], seconds: time[2])
        timeResult = timeString
        totalCount = 0
        sendMessegeToWatch(message: "00 : 00 : 00")
        print(timeResult)
        self.navigationController?.popViewController(animated: true)
    }
    // 메세지 전송
    func sendMessegeToWatch(message: String) {
        
        let messageToSend = ["Value": message, "Count": self.totalCount, "Check": self.isSurfing] as [String: Any]
        WCSession.default.sendMessage(messageToSend, replyHandler: { _ in
            print("전송성공")
        }, errorHandler: {error in
            print(error)
        })
        
    }
    
    // 타이머 카운트
    @objc func timerCount() {
        totalCount += 1
        let time = secondsToMinutes(seconds: totalCount)
        let timeString = makeTimeLabelString(hours: time[0], minutes: time[1], seconds: time[2])
        totalTimeLabel.text = timeString
        sendMessegeToWatch(message: timeString)
    }
    // 타이머 시, 분, 초 계산
    func secondsToMinutes(seconds: Int) -> [Int] {
        var timeArray = [Int]()
        timeArray.append(seconds / 3600)
        timeArray.append((seconds % 3600) / 60)
        timeArray.append((seconds % 3600) % 60)
        return timeArray
    }
    // 타이머 라벨에 들어갈 문자열로 변환
    func makeTimeLabelString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    // 타이머 로그에 들어갈 문자열로 변환
    func makeTimeToText(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += "시 "
        timeString += String(format: "%02d", minutes)
        timeString += "분 "
        timeString += String(format: "%02d", seconds)
        timeString += "초 "
        return timeString
    }
    // 원 생성
    func makeCircle() {
        timeCircle.layer.cornerRadius = timeCircle.layer.bounds.width / 2
        timeCircle.clipsToBounds = true
        timeCircle.layer.borderWidth = 15
        timeCircle.layer.borderColor = UIColor.systemGray6.cgColor
    }
}

extension TimerViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print(activationState)
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(session)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(session)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
//        print(message)
        let value = message["Value"] as? String
        let receiceCount = message["Count"] as? Int
        let surfing = message["Check"] as? Bool
        DispatchQueue.main.async {
            self.totalTimeLabel.text = value
            self.totalCount = receiceCount ?? 0
            self.isSurfing = surfing ?? false
        }
    }
    
}
