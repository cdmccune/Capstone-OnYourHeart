//
//  AddListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/29/22.
//

import UIKit

class AddListViewController: UIViewController {

    //MARK: - Properties
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
        
        colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        colorWellView.addSubview(colorWell)
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        colorWell.title = "Choose a Color"
        colorWell.supportsAlpha = false
        
        var actions: [UIAction] = []
        
        let noAction = UIAction(title: "No") { _ in
            self.isEmotion = false
            self.moodButton.setTitle("No", for: .normal)
        }
        
        let yesAction = UIAction(title: "Yes") { _ in
            self.isEmotion = true
            self.moodButton.setTitle("Yes", for: .normal)
        }
        
        actions.append(noAction)
        actions.append(yesAction)
        let menu = UIMenu(title: "Is it a mood?", options: .displayInline, children: actions)
        moodButton.menu = menu
        moodButton.showsMenuAsPrimaryAction = true
        
        
        
        
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
    
    @IBAction func createListButtonTapped(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


