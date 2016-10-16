//
//  Meme.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/14/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
	let topText: String
	let bottomText: String
	let imageViewImage: UIImage
	let memedImage: UIImage
}

// Figured out how to save Struct Data to UserDefaults so that we don't lose all our Memes whenever the app is restarted
// from this blog - http://redqueencoder.com/property-lists-and-user-defaults-in-swift/

protocol PropertyListReadable {
	func propertyListRepresentation() -> NSDictionary
	init?(propertyListRepresentation:NSDictionary?)
}

extension Meme: PropertyListReadable {
	func propertyListRepresentation() -> NSDictionary {
		let representation: [String:AnyObject] = ["topText": topText as AnyObject, "bottomText": bottomText as AnyObject, "imageViewImage": imageViewImage as AnyObject, "memedImage": memedImage as AnyObject]
		return representation as NSDictionary
	}
	
	init?(propertyListRepresentation: NSDictionary?) {
		guard let values = propertyListRepresentation else {return nil}
		if let topText = values["topText"] as? String,
			let bottomText = values["bottomText"] as? String,
			let imageViewImage = values["imageViewImage"] as? UIImage,
			let memedImage = values["imageViewImage"] as? UIImage {
				self.topText = topText
				self.bottomText = bottomText
				self.imageViewImage = imageViewImage
				self.memedImage = memedImage
		} else {
			return nil
		}
	}
}
