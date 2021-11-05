
import Foundation

class EditViewModel {
    var controller: BaseViewController!
    
    func apiContactEdit(contact: Contact, handler: @escaping (Bool) -> Void) {
        controller.showProgress()
        AFHttp.put(url: AFHttp.API_CONTACT_UPDATE + contact.id!, params: AFHttp.paramsContactUpdate(contact: contact), handler: { [self] response in
            controller.hideProgress()
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
