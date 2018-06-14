//
//  InternetConnection.swift
//  theWearApp
//
//  Created by Валентина on 01.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//


import SystemConfiguration

public class CheckInternet{
    
    class func Connection() -> Bool{
        var zeroAdress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr:
            in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAdress
            .sin_len = UInt8(MemoryLayout.size(ofValue: zeroAdress))
        zeroAdress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAdress)
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){zeroSockAdress in
                SCNetworkReachabilityCreateWithAddress(nil ,zeroSockAdress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false
        {return false}
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
