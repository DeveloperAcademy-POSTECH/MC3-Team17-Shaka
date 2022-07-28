//
//  SignupViewController.swift
//  shaka
//
//  Created by 박원빈 on 2022/07/26.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    var isOk = false
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBAction func checkButton(_ sender: Any) {
        if textField.text == "" {
            checkLabel.text = "사용할 닉네임을 입력해주세요."
            checkLabel.textColor = UIColor.gray
            return
        }
        Task {
            do {
                let result = try await APIClient().checkNickname(textField.text!)
                if result == false {
                    checkLabel.text = "사용 가능한 닉네임 입니다."
                    checkLabel.textColor = UIColor(named: "Bluescale3")
                    signupButton.backgroundColor = UIColor(named: "Bluescale3")
                    isOk = true
                } else {
                    checkLabel.text = "이미 사용 중인 닉네임 입니다."
                    checkLabel.textColor = UIColor.red
                }
            } catch NetworkError.invalidURL {
                checkLabel.text = "문제가 발생했습니다."
                checkLabel.textColor = UIColor.red
                print("Invalid URL ERROR!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLabel.text = ""
        signupButton.backgroundColor = UIColor.gray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        // 닉네임 입력 중에 상태 메세지 비워두기
        checkLabel.text = ""
        signupButton.backgroundColor = UIColor.gray
        isOk = false
        
        return count <= 12
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        if self.isOk == true {
            Task {
                do {
                    let result = try await APIClient().signup(self.textField.text!)
                    if result.nickname != nil {
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let mainViewController = storyboard.instantiateViewController(identifier: "ViewController")
                        mainViewController.modalPresentationStyle = .fullScreen
                        self.present(mainViewController, animated: true)
                    }
                } catch NetworkError.invalidURL {
                    print("Invalid URL ERROR!")
                }
            }
        }
    }
}
