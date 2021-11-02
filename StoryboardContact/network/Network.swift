
import Foundation
import Alamofire

private let IS_TESTER = true
private var DEP_SER = "https://6173e0f0110a7400172231b1.mockapi.io/api/"
private var DEV_SER = "https://6173e0f0110a7400172231b1.mockapi.io/api/"

let headers: HTTPHeaders = [
    "Accept":"application/json",
]

class AFHttp {
    
    // MARK: - AFHttp Requests
    class func get(url: String, params: Parameters, handler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(server(url: url), method: .get, parameters: params, headers: headers).validate().responseJSON(completionHandler: handler)
    }
    
    class func post(url: String, params: Parameters, handler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(server(url: url), method: .post, parameters: params, headers: headers).validate().responseJSON(completionHandler: handler)
    }
    
    class func put(url: String, params: Parameters, handler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(server(url: url), method: .put, parameters: params, headers: headers).validate().responseJSON(completionHandler: handler)
    }
    
    class func del(url: String, params: Parameters, handler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(server(url: url), method: .delete, parameters: params, headers: headers).validate().responseJSON(completionHandler: handler)
    }
    
    // MARK: - AFHttp Methods
    class func server(url: String) -> URL {
        if IS_TESTER {
            return URL(string: DEV_SER + url)!
        }
        return URL(string: DEP_SER + url)!
    }
    
    // MARK: - AFHttp APIs
    static let API_CONTACT_LIST = "contacts"
    static let API_CONTACT_SINGLE = "contacts/" // id
    static let API_CONTACT_CREATE = "contacts"
    static let API_CONTACT_UPDATE = "contacts/" // id
    static let API_CONTACT_DELETE = "contacts/" // id
    
    // MARK: - AFHttp Params
    class func paramsEmpty() -> Parameters {
        let parameters: Parameters = [:]
        return parameters
    }

    class func paramsContactCreate(contact: Contact) -> Parameters {
        let parameters: Parameters = [
            "name": contact.name!,
            "phone": contact.phone!
        ]
        return parameters
    }

    class func paramsContactUpdate(contact: Contact) -> Parameters {
        let parameters: Parameters = [
            "id": contact.id!,
            "name": contact.name!,
            "phone": contact.phone!
        ]
        return parameters
    }
}
