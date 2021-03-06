//
//  HomeViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var favoriteVerseView: UIView!
    @IBOutlet var tableView: UITableView!
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet var favVerseTitleLabel: UILabel!
    @IBOutlet var favVerseContentLabel: UILabel!
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkAuthentication()
        addNotificationObservers()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    //MARK: - Helper Functions
    
    func style() {
        favoriteVerseView.layer.cornerRadius = 25
        favoriteVerseView.layer.borderWidth = 2
        favoriteVerseView.layer.borderColor = Colors.titleBrown.cgColor
        favoriteVerseView.backgroundColor = .systemBackground
    }
    
    func checkAuthentication() {
        
        
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                self.updateViews(uid: user.uid)
            } else {
                self.showNotLoggedInMessage()
            }
        })
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFavVerse),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.favVerseUpdated),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.listAdded),
                                               object: nil)
    }
    
    func showNotLoggedInMessage() {
        tableView.reloadData()
        tableView.isUserInteractionEnabled = false 
        style()
        showLabels()
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
    }
    
    @objc func updateFavVerse() {
        guard let favVerse = FirebaseDataController.shared.favVerse else {return}
        favVerseTitleLabel.text = favVerse.scriptureTitle
        favVerseContentLabel.text = favVerse.scriptureContent
        
    }
    
    func updateViews(uid: String) {
        
        //Disable tab bar
        self.tabBarController?.tabBar.items?.forEach({$0.isEnabled = false})
        self.showSpinner()
        
        //This gets all the lists
        FirebaseDataController.shared.getUserInfo(uid: uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    
                    FirebaseDataController.shared.user = user
                    FirebaseDataController.shared.lists.append(contentsOf: user.lists)
                    self.getListData()
                    self.tableView.reloadData()
                    self.removeSpinner()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getListData() {
        FirebaseDataController.shared.fetchAllLists(for: FirebaseDataController.shared.user.uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    if let favVerse = FirebaseDataController.shared.favVerse {
                        self.favVerseTitleLabel.text = favVerse.scriptureTitle
                        self.favVerseContentLabel.text = favVerse.scriptureContent
                        self.copyrightLabel.isHidden = false
                    }
                    self.style()
                    self.showLabels()
                    self.tabBarController?.tabBar.items?.forEach({$0.isEnabled = true})
                case .failure(let e):
                    print(e)
                }
            }
        }
    }
    
    func showLabels() {
        favVerseTitleLabel.isHidden = false
        favVerseContentLabel.isHidden = false
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDataController.shared.lists.filter({$0.isEmotion}).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.moodCell, for: indexPath) as? MoodTableViewCell else {return UITableViewCell()}
        
        cell.list = FirebaseDataController.shared.lists.filter({$0.isEmotion})[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Storyboard.segueMoodScriptureVC,
           let destinationVC = segue.destination as? MoodScriptureViewController,
           let index = tableView.indexPathForSelectedRow {
            destinationVC.listName = FirebaseDataController.shared.lists.filter({$0.isEmotion})[index.row].name
        }
    }
    
    
}
