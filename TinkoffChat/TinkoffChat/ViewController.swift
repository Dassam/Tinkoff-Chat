//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 06.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userInfoField: UITextView!
    @IBOutlet weak var userImageAvatar: UIImageView!
    @IBOutlet weak var colorText: UILabel!
    
    override func loadView() {
        super.loadView()
        print("loadView")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageAvatar.isUserInteractionEnabled = true
        userImageAvatar.addGestureRecognizer(tapGestureRecognizer)

        userInfoField.delegate = self
        self.userNameField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))// for tapping
      }

    
    
    func dismissKeyboard() {
        userNameField.resignFirstResponder()
    }
    
    

    func textFieldShouldReturn(_ userNameField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        return true
    }
    
    @IBAction func blackColorChange(_ sender: UIButton) {
    colorText.textColor = UIColor.black
    }
    
    @IBAction func redColorChange(_ sender: UIButton) {
    colorText.textColor = UIColor.red
    }
    
    @IBAction func greenColorChange(_ sender: UIButton) {
    colorText.textColor = UIColor.green
    }
    
    @IBAction func blueColorChange(_ sender: UIButton) {
    colorText.textColor = UIColor.blue
    }
    
    @IBAction func pinkColorChange(_ sender: UIButton) {
    colorText.textColor = UIColor.purple
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
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

    
       @IBAction func savexzAction(_ sender: Any)
   {
     //print("Data is saved");
  }


}

