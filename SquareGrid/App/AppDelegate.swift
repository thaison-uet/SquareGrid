//
//  AppDelegate.swift
//  SquareGrid
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let drawingViewController = DrawingViewController()
        self.window?.rootViewController = drawingViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

