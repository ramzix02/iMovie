
import Foundation
struct movieModel: Decodable {
    let results : [Results]
}

struct Main : Decodable{
    let temp : Double
}

struct Results : Decodable {
    let title : String
}
