//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/15/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

	// MARK: Variables 
	
	@IBOutlet weak var imageView: UIImageView!
	var memeIndex: Int = -1
	
	// MARK: View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Add Edit button to Navigation Bar
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editButtonPressed))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Render the meme image
		if memeIndex != -1 {
			imageView.image = SentMemes.sharedInstance.memes[memeIndex].memedImage
		}
	}
	
	func editButtonPressed() {
		
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
		controller.memeIndex = memeIndex

		present(controller, animated: true) { 
			self.navigationController!.popViewController(animated: false)
		}
	}
}
