//
//  AppDelegate.swift
//  ImagePickerExperiment
//
//  Created by Mukul Sharma on 10/6/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		SentMemes.sharedInstance.saveToDefaults()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		SentMemes.sharedInstance.saveToDefaults()
	}
}
