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
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        addNotificationObservers()
        updateViews()
    }
    
    //MARK: - Helper Functions
    
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
    }
    
    func updateViews() {
        tableView.sectionHeaderTopPadding = 0
    }
    


}

extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let list = FirebaseDataController.shared.lists[section]
        let backgroundColor = ColorUtilities.getColorsFromRGB(rGB: list.color)
        
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y:0, width: 320, height: 60)
        myLabel.font = UIFont.boldSystemFont(ofSize: 25)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.textColor = MoodColor(rawValue: list.textColor)?.create ?? .black
        
        let myButton = UIButton()
        myButton.frame = CGRect(x: view.frame.width - 120, y: 0, width: 100, height: 60)
        myButton.setTitleColor(MoodColor(rawValue: list.textColor)?.create ?? .black, for: .normal)
        
        if FirebaseDataController.shared.lists[section].scriptureListEntries.count == 0 {
            myButton.setTitle("Empty", for: .normal)
        } else {
            myButton.setTitle("See All", for: .normal)
            myButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        }
        myButton.tag = section
        
        let headerView = UIView()
        
        headerView.backgroundColor = backgroundColor
        headerView.addSubview(myLabel)
        headerView.addSubview(myButton)
        return headerView
        
    }
    
    @objc func seeAllButtonTapped(sender: UIButton) {
        
        FirebaseDataController.shared.currentListTag = sender.tag
        guard let listDetailVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.listDetailVC) as? UIViewController else {return}
        
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
