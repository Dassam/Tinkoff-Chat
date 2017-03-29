//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 06.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userInfoField: UITextView!
    @IBOutlet weak var userImageAvatar: UIImageView!
    @IBOutlet weak var colorText: UILabel!
    
    @IBAction func blackColorChange(_ sender: UIButton) { colorText.textColor = UIColor.black }
    @IBAction func redColorChange(_ sender: UIButton) { colorText.textColor = UIColor.red }
    @IBAction func greenColorChange(_ sender: UIButton) { colorText.textColor = UIColor.green }
    @IBAction func blueColorChange(_ sender: UIButton) { colorText.textColor = UIColor.blue }
    @IBAction func pinkColorChange(_ sender: UIButton) { colorText.textColor = UIColor.purple }
    
    @IBAction func saveAction(_ sender: Any) {print("Data is saved");}
    
    
    override func loadView()
    {
        super.loadView()
        print("loadView")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("viewDidLoad")

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageAvatar.isUserInteractionEnabled = true
        userImageAvatar.addGestureRecognizer(tapGestureRecognizer)

        userInfoField.delegate = self
        self.userNameField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard)))// for tapping
      }

    
    
    func dismissKeyboard() { userNameField.resignFirstResponder() }
    
    

    func textFieldShouldReturn(_ userNameField: UITextField) -> Bool
    {
        userNameField.resignFirstResponder()
        return true
    }
    
  
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        
        let image = UIImagePickerController()
        image.delegate = self
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
      
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            userImageAvatar.image = image
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

}

