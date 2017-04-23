//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 06.03.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    @IBOutlet weak var userImageAvatar: UIImageView!
    @IBOutlet weak var colorText: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userInfoField: UITextView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadUserData()
        
        userImageAvatar.layer.cornerRadius = 90
        userImageAvatar.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageAvatar.isUserInteractionEnabled = true
        userImageAvatar.addGestureRecognizer(tapGestureRecognizer)

        userInfoField.delegate = self
        self.userNameField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard)))
      }

    //--------------------------------Кнопка назад в Navigation Bar--------------------------
    
    @IBAction func Back(_ sender: Any) { self.dismiss(animated: true, completion: nil) }

    //--------------------------------Изменение цвета текста --------------------------
    
    @IBAction func textColorChange (_ sender: UIButton) { colorText.textColor = sender.backgroundColor }
    
    //--------------------------------Выход из клавиатуры--------------------------
    
    func dismissKeyboard() { userNameField.resignFirstResponder() }
    
    
    func textFieldShouldReturn(_ userNameField: UITextField) -> Bool
    {
        userNameField.resignFirstResponder()
        return true
    }
    
    //--------------------------------Замена картинки аватара--------------------------
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else
            { print("Camera not available") }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        if ( (self.userImageAvatar.image) != (UIImage(named: "ProfilePicture")))
        {
        actionSheet.addAction(UIAlertAction(title: "Delete Photo", style: .destructive, handler: { (action:UIAlertAction) in
            self.userImageAvatar.image = UIImage(named: "ProfilePicture")
        }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
      
        self.present(image, animated: true){}
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        { userImageAvatar.image = image }
        
        else {}
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    { picker.dismiss(animated: true, completion: nil) }
    
    
    //--------------------------- Alert после успешного сохранения профиля --------------------------
    
     func showSuccessfulSaveAlert()
     {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // ----------- Alert о том, что данные не изменились -------
    
    func showAlertDataNotChanged()
    {
        let alert = UIAlertController(title: "Данные не изменились",
                                      message: "Данные с последнего сохранения не изменились, сохранение не требуется", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------------------ Alert, сообщающий об ошибке ---------------------
    
    func showFailedLoadAlert() {
        let alert = UIAlertController(title: "Возникла ошибка при загрузке данных", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func showFailedSaveAlert(withDataProtocol dataProtocol: DataProtocol)
    {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default)
        {
            [unowned self] action in
            self.saveUserData(using: dataProtocol)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //--------------Сохранение и загрузка данных профиля--------------------------

    var startUserData = UserData.createDefaultProfile()
    
    func parseUserData() -> UserData {
        return UserData(
            userName: userNameField.text!,
            userInfo: userInfoField.text,
            colorText: colorText.textColor,
            userImageAvatar: userImageAvatar.image!)
    }
    
    func fillUserData(userData: UserData) {
        userNameField.text = userData.userName
        userInfoField.text = userData.userInfo
        colorText.textColor = userData.colorText
        userImageAvatar.image = userData.userImageAvatar
    }
    
    func enableButtons(enable: Bool) {
        gcdSaveButton.isEnabled = enable
        operationSaveButton.isEnabled = enable
    }
    
    func saveUserData(using dataProtocol: DataProtocol)
    {
        let currentUserData = parseUserData()
        if (currentUserData == startUserData) {
            showAlertDataNotChanged();
        } else {
            enableButtons(enable: false);
            activityIndicator.startAnimating()
            dataProtocol.saveUserData(currentUserData, completion: { (error: Error?) in
                self.activityIndicator.stopAnimating()
                if error == nil
                {
                    self.startUserData = currentUserData
                    self.showSuccessfulSaveAlert()
                }
                else
                {
                    self.showFailedSaveAlert(withDataProtocol: dataProtocol)
                }
                self.enableButtons(enable: true);
            })
        }
    }

    func loadUserData()
    {
        activityIndicator.startAnimating()
        GCDDataManager().loadUserData { (userData, error) in
            self.activityIndicator.stopAnimating()
            self.startUserData = userData ?? UserData.createDefaultProfile()
            self.fillUserData(userData: self.startUserData)
            if error != nil {
                self.showFailedLoadAlert();
            }
        }
    }
    
    //------- Сохранение данных через GCD ----------------

    @IBAction func gcdSaveAction(_ sender: UIButton) {
        saveUserData(using: GCDDataManager())
    }
    
    //------- Сохранение данных через operation ----------------
    
    @IBAction func operationSaveAction(_ sender: UIButton) {
        saveUserData(using: OperationDataManager())
    }
    
   //---------------------------------------------------------------------------------------
  
    override func loadView() { super.loadView() }
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

}

