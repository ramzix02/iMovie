
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
        
//        reachability!.whenReachable = { reachability in
//            if reachability.currentReachabilityStatus == .reachableViaWiFi {
//                print("Reachable via WiFi")
//            } else {
//                print("Reachable via Cellular")
//            }
//            self.flag = true
//        }
//        reachability!.whenUnreachable = { _ in
//            print("Not reachable")
//            self.flag = false
//        }
//
//        do {
//            try reachability!.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//           // self.flag = false
//        }
//        reachability!.stopNotifier()
//        print(flag)
//        return flag
   }
}


