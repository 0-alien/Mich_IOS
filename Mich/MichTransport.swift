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
    
    static func defaultLogin(email: String, password: String, successCallback: @escaping (LoginResponse) -> Void, errorCallback: @escaping (DefaultError) -> Void ){
    
        let reqString = BASE_URL + "auth/login"
        
        let loginRequest = LoginRequest(email: email,password:password,type: 0)
        let payloadJson = loginRequest.toJSONString()
        let parameters: Parameters = ["payload": payloadJson!]
        
        
        
        Alamofire.request(reqString, method: .post, parameters: parameters).responseString { response in
            
            
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                
                let baseResponse = BaseResponse(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    let res = LoginResponse(JSONString: baseResponse!.data!)
                    successCallback(res!)
                    
                }else{
                    
                    let error = DefaultError()
                    error.errorString = "cxondiamde ki mivida mara errori daabruna"
                    
                    
                    errorCallback(error)

                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "cxondiamde ver mivida"
                
                
                errorCallback(error)
                
            }
            
            
        }

        
    }
    
    
}
