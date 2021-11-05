//
//  CreateViewController.swift
//  StoryboardContact
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 23/10/21.
//

import UIKit

class CreateViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    private var contact = Contact()
    var viewmodel = CreateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
    }
    
    // MARK: - Method
    func initViews() {
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 0.5
        bindViewModel()
    }
    
    func bindViewModel() {
        viewmodel.controller = self
    }
    
    // MARK: - Action
    
    @IBAction func addContact(_ sender: UIButton) {
        self.contact.name = nameTextField.text
        self.contact.phone = phoneTextField.text
        viewmodel.apiContactCreate(contact: contact, handler: { isCreated in
            if isCreated {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}
