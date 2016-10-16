//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/15/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

	// MARK: View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showMemeCreationView))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if SentMemes.sharedInstance.memes.count == 0 {
			showMemeCreationView()
		}
		
		tableView.allowsMultipleSelectionDuringEditing = false
		
		tableView.reloadData()
	}
	
	func showMemeCreationView() {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
		present(controller, animated: true, completion: nil)
	}
	
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SentMemes.sharedInstance.memes.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell		
		let meme = SentMemes.sharedInstance.memes[indexPath.row]
		
		cell.customImageView?.image = meme.memedImage
		cell.customLabel.text = "\(meme.topText)...\(meme.bottomText)"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	// MARK: UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
		controller.memeIndex = indexPath.row
		
		navigationController?.pushViewController(controller, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			SentMemes.sharedInstance.memes.remove(at: indexPath.row)
			tableView.reloadData()
		}
	}
}
