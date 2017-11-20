//
//  MichMessagesTransport.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/9/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class MichMessagesTransport {
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
    static let BAN_WORD = 27
    
    static func getMessages(token: String, successCallbackGetMessages: @escaping ([Chat]) -> Void, errorCallbackForGetMessages: @escaping (DefaultError) -> Void) { 
        
        let reqString = BASE_URL + "message/getMine"
        let getMessagesRequest = GetMessagesRequest(token: token)
        let payloadJson = getMessagesRequest.toJSONString()
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if(response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<Chat>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackGetMessages((baseResponse?.data)!)
                }
                else
                {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetMessages(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetMessages(error)
            }
        }
    }
    
    static func getChat(token: String, userId: Int, successCallbackGetChat: @escaping (Chat) -> Void, errorCallbackForGetChat: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "message/get"
        let getChatRequest = GetChatRequest(token: token, userId: userId)
        let payloadJson = getChatRequest.toJSONString()
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if(response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<Chat>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackGetChat((baseResponse?.data)!)
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetChat(error)
                }
            } else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetChat(error)
            }
        }
    }

}
