//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Ofir Elias on 08/07/2019.
//  Copyright © 2019 Ofir Elias. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            do{
                func doSomthing(){
                    let _ = try! Realm()
                }
            }
            return true
        }
    }

