
import UIKit

class ContactViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isReloadData = false
    var viewmodel = ContactViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewmodel.apiContactList()
    }
    
    // MARK: - Method

    func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        initNavigation()
        
        bindViewModel()
        viewmodel.apiContactList()
    }
    
    func bindViewModel() {
        viewmodel.controller = self
        viewmodel.items.bind(to: self) { strongSelf, _ in
            strongSelf.tableView.reloadData()
        }
    }
    
    func initNavigation() {
        let refresh = UIImage(named: "ic_refresh")
        let add = UIImage(named: "ic_add")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: refresh, style: .plain, target: self, action: #selector(leftTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: add, style: .plain, target: self, action: #selector(rightTapped))
        title = "Storyboard Contact"
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
        viewmodel.apiContactList()
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
            self.viewmodel.apiContactList()
            tableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewmodel.items.value[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("ContactTableViewCell", owner: self, options: nil)?.first as! ContactTableViewCell
        
        cell.nameLabel.text = item.name
        cell.phoneLabel.text = item.phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeCompleteContextualActions(forRowAt: indexPath, contact: viewmodel.items.value[indexPath.row])])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [makeDeleteContextualActions(forRowAt: indexPath, contact: viewmodel.items.value[indexPath.row])])
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
            self.viewmodel.apiContactDelete(contact: contact, handler: { isDeleted in
                if isDeleted {
                    self.viewmodel.apiContactList()
                }
            })
        }
    }

}
