
import Foundation

class CreateViewModel {
    var controller: BaseViewController!
    
    func apiContactCreate(contact: Contact, handler: @escaping (Bool) -> Void) {
        controller.showProgress()
        AFHttp.post(url: AFHttp.API_CONTACT_CREATE, params: AFHttp.paramsContactCreate(contact: contact), handler: { [self] response in
            controller.hideProgress()
            switch response.result {
            case .success:
                handler(true)
            case let .failure(error):
                print(error)
                handler(false)
            }
        })
    }
}
