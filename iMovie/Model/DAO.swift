
import Foundation
import Alamofire

class NetworkingClient{
    
    typealias WebServiceResponse = (Dictionary<String,Any>?,Error?) -> Void
    
    func excute(_ url :URL,completion:@escaping WebServiceResponse){
        Alamofire.request(url).validate().responseJSON{
            response in
            if let error = response.error {
                completion(nil,error)
            } else if let jsonArray = response.result.value as? Dictionary<String,Any>{
                completion(jsonArray,nil)
            }else{
                print("error")
            }
        }
    }
}

