//
//  AppDelegate.swift
//  TaskList
//
//  Created by Alexey Efimov on 02.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var dataStore = StorageManager.shared
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    } // Это я посмотрел у Алексея. И то, потому, что искал причину падения приложения. Оказалось, что не тот идентификатор задал в стореджМанагере. Ну и заодно эту часть кода украл, ибо думал, что проблема как-то может быть связана с ней
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataStore.save()
    }


}

