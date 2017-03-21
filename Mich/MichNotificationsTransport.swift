//
//  MichNotificationsTransport.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/21/17.
//  Copyright © 2017 Gigi. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper

class MichNotificationsTransport {
    
    static let BASE_URL = "http://46.101.196.48/public/index.php/api/"
    static let SUCCESS_CODE = 10
    static let INVALID_PAYLOAD_CODE = 20
    static let BAD_REQUEST_CODE = 21
    static let NOT_FOUND_CODE = 22
    static let TOKEN_MISSING_CODE = 23
    static let INVALID_TOKEN_CODE = 24
    static let ALREADY_EXISTS_CODE = 39
    static let INVALID_PARAMETER_CODE = 31
    static let NO_PERMISSION_CODE = 32

    static func getAllNotifications(token: String, successCallbackGetAllNotifications: @escaping ([MichNotification]) -> Void, errorCallbackForGetAllNotifications: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "notification/getAll"
        let getNotificationsRequest = LogoutRequest(token: token)
        let payloadJson = getNotificationsRequest.toJSONString()
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if(response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<MichNotification>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackGetAllNotifications((baseResponse?.data)!)
                }
                else
                {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetAllNotifications(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetAllNotifications(error)
            }
        }
    }
    
    static func markNotificationsSeen(token: String, successCallbackForMarkNotifications: @escaping () -> Void, errorCallbackForMarkNotifications: @escaping (DefaultError) -> Void){
        let reqString = BASE_URL + "notification/seenAll"
        let getNotificationsRequest = LogoutRequest(token: token)
        let payloadJson = getNotificationsRequest.toJSONString()
    
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if (response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<MichNotification>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForMarkNotifications()
                }
                else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForMarkNotifications(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForMarkNotifications(error)
            }
        }
    }
    
    static func getUnseenNotifications(token: String, successCallbackGetUnseenNotifications: @escaping (Int) -> Void, errorCallbackForGetUnseenNotifications: @escaping (DefaultError) -> Void){
        
        let reqString = BASE_URL + "notification/get"
        let getNotificationsRequest = LogoutRequest(token: token)
        let payloadJson = getNotificationsRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if(response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseX<Int>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackGetUnseenNotifications((baseResponse?.data)!)
                }
                else
                {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetUnseenNotifications(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetUnseenNotifications(error)
            }
        }
    }
}
