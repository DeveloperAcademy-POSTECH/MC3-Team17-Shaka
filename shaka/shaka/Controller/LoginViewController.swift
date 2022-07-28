//
//  LoginViewController.swift
//  shaka
//
//  Created by 박원빈 on 2022/07/18.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class LoginViewController: UIViewController {
    private var currentNonce: String?
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        print("login clicked!")
        startSignInWithAppleFlow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(KeyChain.read(key: "accessToken") ?? "accessToken is null")
        // Do any additional setup after loading the view.
    }
    
    private func moveTo(_ storyboard: String, _ viewController: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: viewController)
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화된 임의의 난수
             - 단 한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
             - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
             */
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                authResult?.user.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        // Handle error
                        return
                    }

                    // Send token to your backend via HTTPS
                    // ...
                    print("firebase access token: \(idToken ?? "NULL")")
                    KeyChain.create(key: "accessToken", token: idToken ?? "")

                    // After save accessToken, move to Main or Signup
                    self.checkUser()
                }
            }
        }
    }
}

extension LoginViewController {
    func checkUser() {
        print("check user")
        Task {
            do {
                let user = try await APIClient().checkUser()
                if user.nickname != nil {
                    self.moveTo("Main", "ViewController")
                } else {
                    self.moveTo("Login", "SignupViewController")
                }
            } catch NetworkError.invalidURL {
                print("Invalid URL ERROR!")
            }
        }
    }
}

// Apple Sign in
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
