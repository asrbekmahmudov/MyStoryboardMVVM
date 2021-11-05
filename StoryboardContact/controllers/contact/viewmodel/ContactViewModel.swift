
import Foundation
import Bond

class ContactViewModel {
    let items = Observable<[Contact]>([])
    var controller: BaseViewController!
    
    func apiContactList() {
        controller.showProgress()
        AFHttp.get(url: AFHttp.API_CONTACT_LIST, params: AFHttp.paramsEmpty(), handler: { [self] response in
            controller.hideProgress()
            switch response.result {
            case .success:
                let contacts = try! JSONDecoder().decode([Contact].self, from: response.data!)
                items.value = contacts
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func apiContactDelete(contact: Contact, handler: @escaping (Bool) -> Void) {
        controller.showProgress()
        AFHttp.del(url: AFHttp.API_CONTACT_DELETE + contact.id!, params: AFHttp.paramsEmpty(), handler: { response in
            self.controller.hideProgress()
            switch response.result {
            case .success:
                print(response.result)
                handler(true)
            case let .failure(error):
                print(error)
                handler(false)
            }
        })
    }
    
}
