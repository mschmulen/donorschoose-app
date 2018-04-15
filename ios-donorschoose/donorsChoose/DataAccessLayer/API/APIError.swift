//
//  APIError.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import Foundation

public enum APIError: Error {
    
    case deviceInternetOffline
    case deviceTimout
    case deviceDataNotAllowed
    case connectionLost
    
    case genericNetwork
    case networkSerialize
    
    case unknown(String)
    case silent(String)
    case dev(String)

    var messageTitle:String {
        switch self {
        case .deviceInternetOffline:
            return "No Internet"
        case .genericNetwork:
            return "Server Error"
        case .deviceTimout:
            return "Connecting Error"
        case .deviceDataNotAllowed:
            return "Data Error"
        case .connectionLost:
            return "Connection Error"
        case .networkSerialize:
            return "Server Data Error"
        case .unknown:
            return "Error"
        case .silent:
            return "Error"
        case .dev:
            return "devError"
        }
        
    }
    
    var messageBody:String {
        switch self {
        case .deviceInternetOffline:
            return "No Internet connection, please check your settings"
        case .deviceDataNotAllowed:
            return "Data is not allowed for this application on this device, please check your settings"
        case .genericNetwork:
            return "Error connecting to the server, please try again"
        case .deviceTimout:
            return "Connection timed out, please try again"
        case .connectionLost:
            return "Connection lost, please try again"
        case .networkSerialize:
            return "Error with data from the server"
        case .unknown:
            print("error \(self.localizedDescription)")
        case .silent:
            return "Unknown Error"
        case .dev:
            return "Dev Error"
        }
        return self.localizedDescription
    }
    
    public static func generateFromNetworkError( _ networkError:NSError) -> APIError
    {
        if (networkError.domain == NSURLErrorDomain) {
            if (networkError.code == NSURLErrorNotConnectedToInternet) {
                return APIError.deviceInternetOffline
            }
            else if (networkError.code == NSURLErrorTimedOut) {
                return APIError.deviceTimout
            }
            else if (networkError.code == NSURLErrorDataNotAllowed) {
                return APIError.deviceDataNotAllowed
            }
            else if (networkError.code == NSURLErrorNetworkConnectionLost) {
                return APIError.connectionLost
            }
            else {
                //NSURLErrorCannotConnectToHost
                //NSURLErrorCannotFindHost
                //NSURLErrorCallIsActive
                return APIError.genericNetwork
            }
        }
        else {
            return APIError.unknown(networkError.description)
        }
    }
    
    // MAS TODO Clean up

    public static func generateFromNetworkError( _ networkError:Error) -> APIError
    {
        // MAS TODO Swift 3 , broke
        //      show ( networkError.localizedDescription)
//         if (networkError.domain == NSURLErrorDomain) {
//
//         if (networkError.code == NSURLErrorNotConnectedToInternet) {
//         return APIError.notify_USER_INTERNET_OFFLINE
//         }
//         else if (networkError.code == NSURLErrorTimedOut) {
//         return APIError.notify_USER_TIMEOUT
//         }
//         else if (networkError.code == NSURLErrorDataNotAllowed) {
//         return APIError.notify_USER_DATA_NOT_ALLOWED
//         }
//         else if (networkError.code == NSURLErrorNetworkConnectionLost) {
//         return APIError.notify_USER_CONNECTION_LOST
//         }
//         else {
//         //NSURLErrorCannotConnectToHost
//         //NSURLErrorCannotFindHost
//         //NSURLErrorCallIsActive
//         return APIError.notify_USER_GENERIC_NETWORK
//         }
//         }
//         else {
//         return APIError.unknown(networkError.description)
//         }

        return APIError.genericNetwork
    }

}

