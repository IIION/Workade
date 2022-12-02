//
//  SceneDelegate.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import FirebaseAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: ExploreViewController())
        window?.makeKeyAndVisible()
        Task {
//            try Auth.auth().signOut()
            guard let uid = Auth.auth().currentUser?.uid,
                  let user = try await FirestoreDAO.shared.getUser(userID: uid),
                  let region = user.activeRegion
            else { return }
                    async let count = try? await FirestoreDAO.shared.getActiveUsersNumber(region: region)
                    await window?.rootViewController?.navigationController?.pushViewController(WorkationViewController(region: region, peopleCount: count ?? 0), animated: false)
        }
        
        if let url = connectionOptions.urlContexts.first?.url {
            presentModal(url: url)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            presentModal(url: url)
        }
    }
    
    // 카카오톡으로 공유한 매거진을 모달로 띄우는 함수
    func presentModal(url: URL) {
        let params = self.queryParams(url: url)
        let title = params["title"]?.decodeUrl()
        let imageURL = params["imageURL"]
        let introduceURL = params["introduceURL"]
        guard let title = title, let imageURL = imageURL, let introduceURL = introduceURL else { return }
        let MagazineCellDetailViewController = CellItemDetailViewController(magazine: MagazineModel(title: title, imageURL: imageURL, introduceURL: introduceURL))
        MagazineCellDetailViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(MagazineCellDetailViewController, animated: true)
        }
    }
    
    // 쿼리를 딕셔너리 형태로 반환하는 함수
    func queryParams(url: URL) -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
        if let queryComponents = url.query?.components(separatedBy: "&") {
            for queryComponent in queryComponents {
                let paramComponents = queryComponent.components(separatedBy: "=")
                var object : String? = nil
                if paramComponents.count > 1 {
                    object = paramComponents[1]
                }
                let key = paramComponents[0]
                parameters[key] = object
            }
        }
        return parameters
    }
}

