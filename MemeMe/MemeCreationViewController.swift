//
//  MemeCreationViewController.swift
//  ImagePickerExperiment
//
//  Created by Mukul Sharma on 10/6/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import NotificationCenter

struct Meme {
	let topText: String
	let bottomText: String
	let imageViewImage: UIImage
	let memedImage: UIImage
	
	init(topText: String, bottomText: String, imageViewImage: UIImage, memedImage: UIImage) {
		self.topText = topText
		self.bottomText = bottomText
		self.imageViewImage = imageViewImage
		self.memedImage = memedImage
	}
}

enum MemeViewState {
	case ImageSelected, ImageNotSelected
}

class MemeCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	// MARK: Variables
	
	@IBOutlet weak var bottomToolBar: UIToolbar!
	@IBOutlet weak var topToolBar: UIToolbar!
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var fontPickerView: UIPickerView!
	@IBOutlet weak var changeFontButton: UIBarButtonItem!
	
	var memeTextAttributes = [
		NSStrokeColorAttributeName : UIColor.black,
		NSForegroundColorAttributeName : UIColor.white,
		NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
		NSStrokeWidthAttributeName : "3.0"
	] as [String : Any]
	
	var memes = [Meme]()
	var fontPickerData: [String] = [String]()
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {

		super.viewDidLoad()
		
		// Disable camera button if Source Type camera is not available, for example: Simulator
		if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
			cameraButton.isEnabled = false
		}

		setupFontPicker()
		
		setupTextAttributes(textField: topTextField)
		setupTextAttributes(textField: bottomTextField)
		
		setupUI(forState: .ImageNotSelected)
	}
	
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
		super.viewDidDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}
	
	func setupFontPicker() {
		fontPickerView.dataSource = self
		fontPickerView.delegate = self
		fontPickerView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
		fontPickerData = UIFont.familyNames
	}

	func setupTextAttributes(textField: UITextField) {
		textField.defaultTextAttributes = memeTextAttributes
		textField.textAlignment = .center
		textField.delegate = self
	}
	
	func setupUI(forState: MemeViewState) {
		fontPickerView.isHidden = true
		
		switch forState {
		case .ImageSelected:
			imagePickerView.isHidden = false
			topTextField.isHidden = false
			bottomTextField.isHidden = false
			shareButton.isEnabled = true
			changeFontButton.isEnabled = true
		case .ImageNotSelected:
			imagePickerView.isHidden = true
			topTextField.isHidden = true
			bottomTextField.isHidden = true
			shareButton.isEnabled = false
			changeFontButton.isEnabled = false
			
			// Reset content
			topTextField.text = "TOP"
			bottomTextField.text = "BOTTOM"
		}
	}
	
	// MARK: Notification Center Methods
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		
		// If user started editing bottom text field, move the whole view up
		if (bottomTextField.isFirstResponder) {
			view.frame.origin.y -= getKeyboardHeight(notification: notification)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		
		// If editing of bottom text field is complete, move the view back down
		if (bottomTextField.isFirstResponder) {
			view.frame.origin.y = 0
		}
	}
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.cgRectValue.height
	}

	// MARK: IBActions
	
	@IBAction func pickImageFromLibrary(_ sender: AnyObject) {
		displayImagePicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
	}

	@IBAction func pickImageFromCamera(_ sender: AnyObject) {
		displayImagePicker(sourceType: UIImagePickerControllerSourceType.camera)
	}
	
	@IBAction func shareMeme(_ sender: AnyObject) {
		let memeImage = generateMemedImage()

		// Present the Activity View Controller
		let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)

		// Save the meme object once ViewController's work has been completed
		controller.completionWithItemsHandler = {
			(activity, completed, returnedItems, error) in
			if completed{
				self.saveMeme(image: memeImage)
			}
		}
		
		present(controller, animated: true, completion: nil)
	}
	
	@IBAction func cancelMemeCreation(_ sender: AnyObject) {
		setupUI(forState: .ImageNotSelected)
	}
	
	@IBAction func changeFont(_ sender: AnyObject) {

		// Show Font Picker if not displayed currently.
		// If its already visible, hide it.
		let isHidden = fontPickerView.isHidden
		fontPickerView.isHidden = !isHidden
	}
	
	func saveMeme(image: UIImage) {
		
		// At this point, our text fields and imageview are initialized and unwrapping the images and text is safe.
		let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, imageViewImage: imagePickerView.image!, memedImage: image)
		memes.append(meme)
		
		// TODO: Need to find a way to store meme data to disk using NSArchiver of NSUserDefaults
	}
	
	func displayImagePicker(sourceType:UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		present(imagePicker, animated: true, completion: nil)
	}
	
	func generateMemedImage()->UIImage
	{
		// Hide toolbars so they don't show up in the Meme image
		configureBarVisibility(isHidden: false)
		
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame,
		                   afterScreenUpdates: true)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		// Display toolbars again
		configureBarVisibility(isHidden: false)
		
		return image
	}
	
	func configureBarVisibility(isHidden: Bool) {
		topToolBar.isHidden = isHidden
		bottomToolBar.isHidden = isHidden
	}
	
	// MARK: ImagePicker Delegate Methods
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		var state = MemeViewState.ImageSelected
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imagePickerView.contentMode = .scaleAspectFit
			imagePickerView.image = image
		} else{
			
			// Setup UI for the situation where we don't have a selected image
			print("Something went wrong with Image selection.")
			state = .ImageNotSelected
		}
		
		dismiss(animated: true, completion: nil)
		
		DispatchQueue.main.async {
			self.setupUI(forState: state)
		}
	}
	
	// Implementing this method is optional but heavily recommended
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: TextField Delegate Methods
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if (textField == topTextField && textField.text == "TOP") {
			textField.text = ""
		}
		
		if (textField == bottomTextField && textField.text == "BOTTOM") {
			textField.text = ""
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if (textField == topTextField && textField.text == "") {
			textField.text = "TOP"
		}
		
		if (textField == bottomTextField && textField.text == "") {
			textField.text = "BOTTOM"
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: UIPickerViewDataSource Methods
	
	// returns the number of 'columns' to display.
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	// returns the # of rows in each component..
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return fontPickerData.count
	}
	
	// MARK: UIPickerViewDelegate Methods
	
	// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
	// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
	// If you return back a different object, the old one will be released. the view will be centered in the row rect
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return fontPickerData[row]
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		// Update the text fields with newly selected Font
		memeTextAttributes[NSFontAttributeName] = UIFont(name: fontPickerData[row], size: 40)!
		setupTextAttributes(textField: topTextField)
		setupTextAttributes(textField: bottomTextField)
		
		pickerView.isHidden = true
	}
}
