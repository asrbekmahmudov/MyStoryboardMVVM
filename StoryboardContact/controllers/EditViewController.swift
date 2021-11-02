//
//  EditViewController.swift
//  StoryboardContact
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 23/10/21.
//

import UIKit

class EditViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var contact = Contact()
    
    func apiContactEdit(contact: Contact) {
        showProgress()
        
        AFHttp.put(url: AFHttp.API_CONTACT_UPDATE + contact.id!, params: AFHttp.paramsContactUpdate(contact: contact), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                print(response.result)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    // MARK: - Method
    func initViews() {
        initNavigation()
        nameTextField.text = contact.name
        phoneTextField.text = contact.phone
        editButton.layer.cornerRadius = 5
        editButton.layer.borderWidth = 0.5
    }
    
    func initNavigation() {
        title = "Edit Contact"
    }
    
    // MARK: - Action
    @IBAction func editContact(_ sender: Any) {
        contact.name = nameTextField.text
        contact.phone = phoneTextField.text
        apiContactEdit(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
}
