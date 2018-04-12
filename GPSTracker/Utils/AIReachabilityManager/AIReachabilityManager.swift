//
//  AIReachabilityManager.swift
//  Swift3CodeStucture
//
//  Created by Ravi Alagiya on 11/24/16.
//  Copyright © 2016 agilepc-100. All rights reserved.
// 


import UIKit
import ReachabilitySwift

class AIReachabilityManager: NSObject {

    var reachability:Reachability!
    
    static let sharedManager : AIReachabilityManager = {
        let instance = AIReachabilityManager()
        return instance
    }()
    
    func isInternetAvailableForAllNetworks() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.isReachable || reachability!.isReachableViaWiFi || self.reachability!.isReachableViaWWAN
        }
        else{
            return reachability!.isReachable || reachability!.isReachableViaWiFi || reachability!.isReachableViaWWAN
        }
    }
 
    func doSetupReachability() {
        
        do{
            let reachability = try Reachability()!
            
            self.reachability = reachability
        }
        catch ReachabilityError.FailedToCreateWithAddress(_){
            return
        }
        catch{}
        
        reachability.whenReachable = { reachability in
        }
        reachability.whenUnreachable = { reachability in
        }
        do {
            try reachability.startNotifier()
        }
        catch {
        }
    }
    deinit{
        reachability.stopNotifier()
        reachability = nil
    }
    
}
