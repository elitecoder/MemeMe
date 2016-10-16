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
	var meme: Meme? = nil
	
	// MARK: View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Add Edit button to Navigation Bar
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailViewController.editButtonPressed))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Render the meme image
		if let meme = self.meme {
			imageView.image = meme.memedImage
		}
	}
	
	func editButtonPressed() {
		
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
		controller.meme = meme

		present(controller, animated: true) { 
			self.navigationController!.popViewController(animated: false)
		}
	}
}
