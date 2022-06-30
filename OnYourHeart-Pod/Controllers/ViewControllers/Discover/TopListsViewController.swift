//
//  TopListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/30/22.
//

import UIKit

class TopListsViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TopListsViewController: UITableViewDelegate, UITableViewDataSource {
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
        myButton.setTitle("See All", for: .normal)
        myButton.setTitleColor(MoodColor(rawValue: list.textColor)?.create ?? .black, for: .normal)
        
        myButton.tag = section
        
        myButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        
//        myButton.backgroundColor = .blue
        
    
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