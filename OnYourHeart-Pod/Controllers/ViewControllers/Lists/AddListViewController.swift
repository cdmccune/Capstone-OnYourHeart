//
//  AddListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/29/22.
//

import UIKit
import SwiftUI

class AddListViewController: UIViewController {

    //MARK: - Properties
    
    var list: ListItem?
    
    var doneBarButton: UIBarButtonItem?
    @IBOutlet var deleteButton: UIButton!
    var color: UIColor?
    var colorWell: UIColorWell!
    var isEmotion = false
    @IBOutlet var listNameTextField: UITextField!
    @IBOutlet var colorWellView: UIView!
    @IBOutlet var moodButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    //MARK: - Helper Functions
    func updateViews() {
        listNameTextField.delegate = self
        
        colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        colorWellView.addSubview(colorWell)
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        colorWell.title = "Choose a Color"
        colorWell.supportsAlpha = false
        
        var actions: [UIAction] = []
        
        let noAction = UIAction(title: "No") { _ in
            self.isEmotion = false
            self.moodButton.setTitle("No", for: .normal)
            
            if self.color != nil, let text = self.listNameTextField.text, text != "" {
                self.createListButton.isEnabled = true
            }
            
        }
        
        let yesAction = UIAction(title: "Yes") { _ in
            self.isEmotion = true
            self.moodButton.setTitle("Yes", for: .normal)
            
            if self.color != nil, let text = self.listNameTextField.text, text != "" {
                self.createListButton.isEnabled = true
            }
            
        }
        
        actions.append(noAction)
        actions.append(yesAction)
        let menu = UIMenu(title: "Is it an emotion?", options: .displayInline, children: actions)
        moodButton.menu = menu
        moodButton.showsMenuAsPrimaryAction = true
        
        if let list = list {
            
            let uiColor = ColorUtilities.getColorsFromRGB(rGB: list.color)
            color = uiColor
            colorWell.selectedColor = uiColor
            
            isEmotion = list.isEmotion
            isEmotion ? moodButton.setTitle("Yes", for: .normal) : moodButton.setTitle("No", for: .normal)
            
            listNameTextField.text = list.name
            listNameTextField.isEnabled = false
            createListButton.setTitle("Update List", for: .normal)
            
            deleteButton.isHidden = false
        }
        
        
    }
    
    @objc func colorWellValueChanged(_ sender: Any) {
        self.color = colorWell.selectedColor
        
        if self.color != nil, let text = listNameTextField.text, text != "" {
            createListButton.isEnabled = true
        }
    }
    
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
        if self.color != nil, let text = listNameTextField.text, text != "" {
            createListButton.isEnabled = true
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let list = list else {
            return
        }

        FirebaseDataController.shared.deleteList(list: list) { result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.listAdded), object: self)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    @IBAction func createListButtonTapped(_ sender: Any) {
        if let list = list {
            guard let color = color else {return}
            
            let textColor = ColorUtilities.blackOrWhiteText(color: color).rawValue
            list.color = ColorUtilities.getRGBFromColor(color: color)
            
            FirebaseDataController.shared.updateList(list: list, color: color, textColor: textColor, isEmotion: isEmotion) { result in
                switch result {
                case .success(_):
                    print("success")
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.listAdded), object: self)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
            
        } else {
        
        guard let text = listNameTextField.text, text != "", let color = color else {return}
        let rgb = ColorUtilities.getRGBFromColor(color: color)
        let newList = ListItem(name: text, color:rgb, isEmotion: self.isEmotion)
        
        FirebaseDataController.shared.createNewList(list: newList) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    FirebaseDataController.shared.user.lists.append(newList)
                    FirebaseDataController.shared.lists.append(newList)
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.listAdded), object: self)
                case .failure(let error):
                    print(error)
                }
            }
        }
        }
    }
}



extension AddListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        self.navigationItem.setRightBarButton(doneBarButton, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    @objc func doneClicked() {
        self.listNameTextField.resignFirstResponder()
    }
                                            
}


