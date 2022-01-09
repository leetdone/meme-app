//
//  ViewController.swift
//  MemeV1.0
//
//  Created by lindong on 12/27/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var buttonText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    
    //set the outlet to default
    @IBAction func cancelButton(_ sender: Any) {
        topText.text = "T O P"
        buttonText.text = "BUTTOM"
        imagePicker.image = nil
        shareButton.isEnabled = false
    }
    
    //generate a meme, allow users to share it, back to rootViewController after action
    @IBAction func shareButton(_ sender: Any) {
        let meme = generateMemedImage()
        let showMeme = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(showMeme, animated: true, completion: nil)
        showMeme.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed{
                self.save()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    //save meme as an instance in struct
    func save(){
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topText.text!, buttonText: buttonText.text!, originalImage: imagePicker.image!, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    //hide buttons in the screen, generate a meme
    func generateMemedImage() -> UIImage {
        hideTexts(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideTexts(false)
        return memedImage
    }
    
    //hide all the buttons
    func hideTexts(_ hide: Bool){
        shareButton.isHidden = hide
        cancelButton.isHidden = hide
        camera.isHidden = hide
        albumButton.isHidden = hide
    }
    
    //set characteristic fonts
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.yellow,//NSAttributedString.Key can be omited
        .foregroundColor: UIColor.blue,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 66)!,
        .strokeWidth:  -3//find answer on the Internet
    ]
    
    //allow users to pick up an image
    func presentPickerViewController(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //pick an image from camera
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    //pick an image from album
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    //when viewController is loaded, set text fields and check whether camera is available
    override func viewDidLoad() {
        super.viewDidLoad()
        initText(topText,"T O P")
        initText(buttonText, "BUTTOM")
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //initialize text field
    func initText(_ textField: UITextField, _ text: String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = NSTextAlignment.center
    }
    
    //hide the navigation bar, if image is not picked, disable share button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
        subscribeToKeyboardNotifications()
        if imagePicker.image == nil{
            shareButton.isEnabled = false
        }
    }
    
    //when view disappear, show the tab bar for other view controllers
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //get notification if keyboard shows or disappears
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //scroll screen up when editing the buttonText
    @objc func keyboardWillShow(_ notification:Notification) {
        if buttonText.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //scroll screen down after editing the buttonText
    @objc func keyboardWillHide(_ notification:Notification) {
        if buttonText.isFirstResponder{
        view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //save picked image. only enable sharebutton when image is picked up
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePicker.image = image
        }
        shareButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    //delete default text when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "T O P" || textField.text == "BUTTOM"{
            textField.text = ""
        }
    }
    
    //disable keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}
