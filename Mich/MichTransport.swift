//
//  MichTransport.swift
//  Mich
//
//  Created by zuraba on 1/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class MichTransport {
    
    static let BASE_URL = "http://138.68.73.21/public/index.php/api/"
    static let SUCCESS_CODE = 10
    static let INVALID_PAYLOAD_CODE = 20
    static let BAD_REQUEST_CODE = 21
    static let NOT_FOUND_CODE = 22
    static let TOKEN_MISSING_CODE = 23
    static let INVALID_TOKEN_CODE = 24
    static let ALREADY_EXISTS_CODE = 39
    static let INVALID_PARAMETER_CODE = 31
    static let NO_PERMISSION_CODE = 32
    
    static func defaultLogin(email: String, password: String, successCallback: @escaping (LoginResponse) -> Void, errorCallback: @escaping (DefaultError) -> Void ){
    
        let reqString = BASE_URL + "auth/login"
        
        let loginRequest = LoginRequest(email: email,password:password,type: 0)
        let payloadJson = loginRequest.toJSONString()
        let parameters: Parameters = ["payload": payloadJson!]
        
        
        
        Alamofire.request(reqString, method: .post, parameters: parameters).responseString { response in
            
            
//           print(response.request)  // original URL request
//           print(response.response) // HTTP URL response
//           print(response.data)     // server data
//           print(response.result)   // result of response serialization
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<LoginResponse>(JSONString: JString)
        
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    let res = baseResponse!.data!
                    successCallback(res)
                    
                }else{

                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallback(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallback(error)
                
            }
            
            
        }

        
    }
    
    static func register(email: String, password: String, firstname: String, lastname: String, successCallbackForRegister: @escaping () -> Void, errorCallbackForRegister: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "auth/register"
        
        let registerRequest = RegisterRequest(email: email,password:password,firstname:firstname,lastname:lastname, type: 0)
        let payloadJson = registerRequest.toJSONString()
        let parameters: Parameters = ["payload": payloadJson!]
        
        
        Alamofire.request(reqString, method: .post, parameters: parameters).responseString { response in
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<RegisterResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                        
                    successCallbackForRegister()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForRegister(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForRegister(error)
                
            }
        
        }

        
    }
    
}
