//
//  Service.swift
//  YTDemoTask
//
//  Created by zeyad on 3/24/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation
import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchChannels( complete: @escaping ( _ success: Bool, _ channels: [Channel], _ error: APIError? )->() )
}

class APIService:APIServiceProtocol {
    var desiredChannelsArray = ["Apple", "Google", "Microsoft","facebook" , "twitter"]
    var channelIndex = 0
    
    func fetchChannels( complete: @escaping ( _ success: Bool, _ channels: [Channel], _ error: APIError? )->()) {
    
    var channels = [Channel]()
    for channel in desiredChannelsArray {
        
        let urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=\(channel)&key=AIzaSyB43vfEpUD3NFH5ZV3l1UXcJOZ5aZ7SIZQ"
        
            let url = URL(string:urlString)
        
           let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
                if error != nil {
                    print(error!)
                }else {
                    let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(str!)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let channel = try! decoder.decode(Channel.self, from: data!)
                    channels.append(channel)
                    
                }
            }
        task.resume()
    }
    
    complete(true, channels , nil)


    }
}
