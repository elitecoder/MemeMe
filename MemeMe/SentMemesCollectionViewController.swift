//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Mukul Sharma on 10/15/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

	@IBOutlet weak var layout: UICollectionViewFlowLayout!
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SentMemesCollectionViewController.showMemeCreationView))
		
		let space: CGFloat = 1.5
		let dimension = (view.frame.size.width - (2 * space)) / 3.0
		
		layout.minimumLineSpacing = space
		layout.minimumInteritemSpacing = space
		layout.itemSize = CGSize(width: dimension, height: dimension)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if SentMemes.sharedInstance.memes.count == 0 {
			showMemeCreationView()
		}
		
		collectionView?.reloadData()
	}
	
	func showMemeCreationView() {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
		present(controller, animated: true, completion: nil)
	}

	// MARK: UICollectionViewDataSource
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return SentMemes.sharedInstance.memes.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
		
		let meme = SentMemes.sharedInstance.memes[indexPath.row]
		cell.customImageView.image = meme.memedImage
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
		controller.meme = SentMemes.sharedInstance.memes[indexPath.row]
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
