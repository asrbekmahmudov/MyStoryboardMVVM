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
    
    func apiPostCreate(contact: Contact) {
        showProgress()
        
        AFHttp.post(url: AFHttp.API_CONTACT_CREATE, params: AFHttp.paramsContactCreate(contact: contact), handler: { response in
            self.hideProgress()
            switch response.result {
            case .success:
                //let post = try! JSONDecoder().decode(Post.self, from: response.data!)
                self.navigationController?.popViewController(animated: true)
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
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 0.5
    }
    
    // MARK: - Action
    
    @IBAction func addContact(_ sender: UIButton) {
        self.contact.name = nameTextField.text
        self.contact.phone = phoneTextField.text
        self.apiPostCreate(contact: contact)
    }
    
}
