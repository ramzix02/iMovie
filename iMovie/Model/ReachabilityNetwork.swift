
import ReachabilitySwift
import Foundation

class ReachabilityNetwork{
    
    static var flag = true
    
    static func getReachabilityInfo() -> Bool{
        let reachability = try! Reachability()
        if  (reachability?.isReachable)!
        {
            print("is reachable")
            return true
        }
        else
        {
            print("is not reachable")
            return false
        }
        
   }
}


