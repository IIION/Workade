//
//  FirebaseManager.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/25.
//

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import Foundation
import GoogleSignIn

final class FirebaseManager: NSObject {
    // MARK: - Properties
    static let shared = FirebaseManager()
    private var currentNonce: String?
    lazy private var authorizationController = ASAuthorizationController(authorizationRequests: [createAppleIDRequest()])
    private var appleSigninCompletion: (() -> Void)!
    private var appleSignupCompletion: (() -> Void)!
    private override init() {
        super.init()
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
    }
    
    
    func touchUpAppleButton(appleSignupCompletion: @escaping () -> Void, appleSigninCompletion: @escaping () -> Void) {
        self.appleSigninCompletion = appleSigninCompletion
        self.appleSignupCompletion = appleSignupCompletion
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out Missing")
        }
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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
                if length == 0 {
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
    
    func touchUpGoogleButton(signupCompletion: @escaping () -> Void, signinCompletion: @escaping () -> Void, region: Region) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: (UIApplication.shared.keyWindow?.rootViewController)!) { user, error in
            guard error == nil else { return }
            
            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            // access token 부여 받음
            
            // 파베 인증정보 등록
            Auth.auth().signIn(with: credential) { result, error in
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let user = result?.user {
                    Task {
                        if try await FirestoreDAO.shared.getUser(userID: user.uid) != nil {
                            DispatchQueue.main.async {
                                Task {
                                    guard let userInfo = try await FirestoreDAO.shared.getUser(userID: user.uid) else { return }
                                    UserManager.shared.user.value = userInfo
                                    try await FirestoreDAO.shared.createActiveUser(user: ActiveUser(id: userInfo.id, job: userInfo.job, region: region, startDate: .now))
                                }
                                signinCompletion()
                            }
                        } else {
                            DispatchQueue.main.async {
                                signupCompletion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUser() -> Firebase.User? {
        return Auth.auth().currentUser
    }
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension FirebaseManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 몇 가지 표준 키 검사를 수행
            // 1️⃣ 현재 nonce가 설정되어 있는지 확인
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // 2️⃣ ID 토큰을 검색하여
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            // 3️⃣ 문자열로 변환
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }
            
            // 4️⃣
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            // 5️⃣
            Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
                // 인증 결과에서 Firebase 사용자를 검색하고 사용자 정보를 표시할 수 있다.
                if let user = authDataResult?.user {
                    Task { [weak self] in
                        if (try await FirestoreDAO.shared.getUser(userID: user.uid)) == nil {
                            DispatchQueue.main.async { [weak self] in
                                self?.appleSignupCompletion()
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                Task {
                                    guard let userInfo = try await FirestoreDAO.shared.getUser(userID: user.uid) else { return }
                                    UserManager.shared.user.value = userInfo
                                }
                                self?.appleSigninCompletion()
                            }
                        }
                    }
                }
                
                if error != nil {
                    print(error?.localizedDescription ?? "error" as Any)
                    return
                }
            }
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension FirebaseManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter{$0.isKeyWindow}.first!
    }
}
