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
    var viewmodel = EditViewModel()
    
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
        bindViewModel()
    }
    
    func bindViewModel() {
        viewmodel.controller = self
    }
    
    func initNavigation() {
        title = "Edit Contact"
    }
    
    // MARK: - Action
    @IBAction func editContact(_ sender: Any) {
        contact.name = nameTextField.text
        contact.phone = phoneTextField.text
        viewmodel.apiContactEdit(contact: contact, handler: { isEdited in
            if isEdited {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
