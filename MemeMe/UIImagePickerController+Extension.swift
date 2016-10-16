//
//  UIImagePickerController+Extension.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/13/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

extension UIImagePickerController {

	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		// Make sure UIImagePickerController supports both Landscape and Portrait mode
		return [UIInterfaceOrientationMask.landscape, UIInterfaceOrientationMask.portrait]
	}
}
