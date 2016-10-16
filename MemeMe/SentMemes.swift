//
//  SentMemes.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/15/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

class SentMemes {
	
	static let sharedInstance = SentMemes()
	
	let userDefaultsKey = "SavedMemes"
	
	var memes: [Meme]
	
	private init() { //This prevents others from using the default '()' initializer for this class.
		memes = [Meme]()
		
		restoreFromDefaults()
	}
	
	func saveToDefaults() {
		
		var memesArray = [Data]()
		for meme in memes {
			
			let memeData: Data = NSKeyedArchiver.archivedData(withRootObject: meme.propertyListRepresentation())
			memesArray.append(memeData)
		}
		
		UserDefaults.standard.set(memesArray, forKey: userDefaultsKey)
	}
	
	func restoreFromDefaults() {
		
		let memesArray = UserDefaults.standard.object(forKey: userDefaultsKey) as? [Data]
		
		if let array = memesArray {
			for memeData in array {
				
				let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: memeData) as? [String : Any]
				if let meme = Meme.init(propertyListRepresentation: dictionary as NSDictionary?) {
					memes.append(meme)
				}
			}
		}
	}

}
