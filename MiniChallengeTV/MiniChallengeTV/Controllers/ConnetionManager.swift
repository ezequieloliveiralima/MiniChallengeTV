//
//  ConnetionManager.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/20/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

class ConnectionManager {
    
    static let cacheURL = NSURLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
    static let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        config.URLCache = cacheURL
        return NSURLSession(configuration: config)
    }()
    
    class func openConnection(uri: String, completionHandler:((NSData?, NSURLResponse?, NSError?) -> Void)) {
        print(uri)
        guard let url = NSURL(string: uri) else {
            return
        }
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30.0)
        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(data, response, error)
            })
        }).resume()
    }
}