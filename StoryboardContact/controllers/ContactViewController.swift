//
//  ContactViewController.swift
//  StoryboardContact
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 23/10/21.
//

import UIKit

class ContactViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: Array<Contact> = Array()
    var isReloadData = false
    
    func refreshableTableView(contacts: [Contact]) {
        self.items = contacts
        self.tableView.reloadData()
    }
    
    func apiContactList() {
        showProgress()
        
        AFHttp.get(url: AFHttp.API_CONTACT_LIST, params: AFHttp.paramsEmpty(), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                let contacts = try! JSONDecoder().decode([Contact].self, from: response.data!)
                self.refreshableTableView(contacts: contacts)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func apiContactDelete(contact: Contact) {
        showProgress()
        
        AFHttp.del(url: AFHttp.API_CONTACT_DELETE + contact.id!, params: AFHttp.paramsEmpty(), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                print(response.result)
                self.apiContactList()
            case let .failure(error):
                print(error)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.apiContactList()
    }
    
    // MARK: - Method

    func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        initNavigation()
        
        apiContactList()
    }
    
    func initNavigation() {
        let refresh = UIImage(named: "ic_refresh")
        let add = UIImage(named: "ic_add")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: refresh, style: .plain, target: self, action: #selector(leftTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: add, style: .plain, target: self, action: #selector(rightTapped))
        title = "Storyboard Post"
    }
    
    func callCreateViewController() {
        let viewController = CreateViewController(nibName: "CreateViewController", bundle: nil)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func callEditViewConroller(contact: Contact) {
        let viewController = EditViewController(nibName: "EditViewController", bundle: nil)
        viewController.contact = contact
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @objc func leftTapped() {
        apiContactList()
    }
    
    @objc func rightTapped() {
        callCreateViewController()
    }
    
    

    // MARK: - Table View
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position >= 0 {
            isReloadData = false
        }
        if position < -120 && !isReloadData {
            hud.position = .topCenter
            isReloadData = true
            self.apiContactList()
            tableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("ContactTableViewCell", owner: self, options: nil)?.first as! ContactTableViewCell
        
        cell.nameLabel.text = item.name
        cell.phoneLabel.text = item.phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeCompleteContextualActions(forRowAt: indexPath, contact: items[indexPath.row])])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualActions(forRowAt: indexPath, contact: items[indexPath.row])])
    }
    
    // MARK: - Contextual Actions
    private func makeCompleteContextualActions(forRowAt indexPath: IndexPath, contact: Contact) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Edit") { (action, swipeButtonView, completion) in
            print("COMPLETE HERE")
            self.callEditViewConroller(contact: contact)
        }
    }
    
    private func makeDeleteContextualActions(forRowAt indexPath: IndexPath, contact: Contact) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
            print("DELETE HERE")
            completion(true)
            self.apiContactDelete(contact: contact)
        }
    }

}
