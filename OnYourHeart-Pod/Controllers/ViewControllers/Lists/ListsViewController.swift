//
//  ListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit
import FirebaseAuth

class ListsViewController: UIViewController {
    
    //MARK: - Properties
   
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editListButton: UIButton!
  
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        addNotificationObservers()
        updateViews()
        setUpEditButton()
    }
    
    //MARK: - Helper Functions
    
    func setUpEditButton() {
        
        guard Auth.auth().currentUser != nil else {
            editListButton.addTarget(self, action: #selector(notLoggedInAlert), for: .touchUpInside)
            return
        }
        
        let lists = FirebaseDataController.shared.user.lists
        var actions: [UIAction] = []
        lists.forEach { list in
            let action = UIAction(title: list.name, image: UIImage(named: "X.circle")) { editAction in
                self.editList(list)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Edit a List", options: .displayInline, children: actions)
        editListButton.menu = menu
    }
    
    @objc func notLoggedInAlert() {
        LoginUtilities.presentNotLoggedInAlert(viewController: self, tabbar: self.tabBarController)
    }
    
    func editList(_ list: ListItem) {
        
        guard let editListVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.addListVC) as? AddListViewController else {return}
        
        editListVC.list = list
        
        self.navigationController?.pushViewController(editListVC, animated: true)
        
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.scriptureAdded),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.listAdded),
                                               object: nil)
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
        setUpEditButton()
    }
    
    func updateViews() {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.titleBrown]
        tableView.sectionHeaderTopPadding = 0
    }
    
    @IBAction func addListButtonTapped(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            notLoggedInAlert()
            return
        }
        guard let addListVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.addListVC) as? AddListViewController else {return}
        navigationController?.pushViewController(addListVC, animated: true)
    }
    
    
}





extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let list = FirebaseDataController.shared.lists[section]
        let backgroundColor = ColorUtilities.getColorsFromRGB(rGB: list.color)
        
        let myButton = UIButton()
        let myLabel = UILabel()
        let headerView = UIView()
        
        headerView.backgroundColor = backgroundColor
        headerView.addSubview(myLabel)
        headerView.addSubview(myButton)
        
        myLabel.frame = CGRect(x: 20, y:0, width: view.frame.width - 140, height: 60)
        myLabel.font = UIFont.boldSystemFont(ofSize: 25)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.textColor = MoodColor(rawValue: list.textColor)?.create ?? .black
        myLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        myLabel.rightAnchor.constraint(equalTo: myButton.leftAnchor, constant: 10).isActive = true
        myLabel.numberOfLines = 0
        
        
        
        myButton.frame = CGRect(x: view.frame.width - 120, y: 0, width: 100, height: 60)
        myButton.setTitleColor(MoodColor(rawValue: list.textColor)?.create ?? .black, for: .normal)
        myButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 20).isActive = true
        myButton.leftAnchor.constraint(equalTo: myLabel.rightAnchor, constant: 20).isActive = true
        
        if FirebaseDataController.shared.lists[section].scriptureListEntries.count == 0 {
            myButton.setTitle("Empty", for: .normal)
        } else {
            myButton.setTitle("See All", for: .normal)
            myButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        }
        myButton.tag = section
        
        return headerView
        
    }
    
    @objc func seeAllButtonTapped(sender: UIButton) {
        
        FirebaseDataController.shared.currentListTag = sender.tag
        guard let listDetailVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.listDetailVC) as? ListDetailViewController else {return}
        
        self.navigationController?.pushViewController(listDetailVC, animated: true)
        
    
        
    //ListDetailVC
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FirebaseDataController.shared.lists.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FirebaseDataController.shared.lists[section].name
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = FirebaseDataController.shared.lists[section].scriptureListEntries.count
        
        return count < 3 ? count : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.listCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = FirebaseDataController.shared.lists[indexPath.section].scriptureListEntries[indexPath.row].scriptureTitle
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
