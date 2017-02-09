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

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
class MichTransport {
    
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
    
    
    
    
    static func defaultLogin(username: String, password: String, successCallback: @escaping (LoginResponse) -> Void, errorCallback: @escaping (DefaultError) -> Void ){
    
        let reqString = BASE_URL + "auth/login"
        
        let loginRequest = LoginRequest(username: username,password:password,type: 0)
        let payloadJson = loginRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
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
                    
                    
                    ////// tokenis ageba
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.token = baseResponse?.data?.token
                   
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
    
    static func register(username:String, email: String, password: String, name: String, successCallbackForRegister: @escaping () -> Void, errorCallbackForRegister: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "auth/register"
        
        let registerRequest = RegisterRequest(username:username, email: email,password:password,name:name)
        let payloadJson = registerRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
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
    
    
    static func sendrecovery(username: String, successCallbackForRecovery: @escaping () -> Void, errorCallbackForRecovery: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "auth/sendRecovery"
        
        let sendRecoveryResquest = SendRecoveryRequest(username: username)
        let payloadJson = sendRecoveryResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            

            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<SendRecoveryResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    ////// tokenis ageba
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.token = baseResponse?.data?.token
                    successCallbackForRecovery()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForRecovery(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForRecovery(error)
                
            }
            
            
        }
        
        
    }
    

  
    static func checkcode(token: String, code: String, successCallbackForCheckCode: @escaping () -> Void, errorCallbackForCheckCode: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "auth/checkCode"
        
        let checkCodeRequest = CheckCodeRequest(token: token, code: code)
        let payloadJson = checkCodeRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<CheckCodeResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                   
                    successCallbackForCheckCode()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForCheckCode(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForCheckCode(error)
                
            }
            
            
        }
        
        
    }
    

    
    static func recover(token: String, password: String, successCallbackForRecover: @escaping () -> Void, errorCallbackForRecover: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "auth/recover"
        
        let recoverRequest = RecoverRequest(token: token, password: password)
        let payloadJson = recoverRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<RecoveryResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    successCallbackForRecover()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForRecover(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForRecover(error)
                
            }
            
            
        }
        
        
    }

    
    
    
    static func logout(token: String, successCallbackForLogout: @escaping () -> Void, errorCallbackForLogout: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "auth/logout"
        
        let logoutResquest = LogoutRequest(token: token)
        let payloadJson = logoutResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<LogoutResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    successCallbackForLogout()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForLogout(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForLogout(error)
                
            }
            
            
        }
        
        
    }
    
    
    
    static func getcurrentuser(token: String, successCallbackForgetcurrentuser: @escaping (User) -> Void, errorCallbackForgetcurrentuser: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/get"
        
        let getcurrentuserResquest = GetCurrentUserRequest(token: token)
        let payloadJson = getcurrentuserResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetcurrentuser(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForgetcurrentuser(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetcurrentuser(error)
                
            }
            
            
        }
        
        
    }
    
    
    static func getuser(token: String, id: Int, successCallbackForgetuser: @escaping (User) -> Void, errorCallbackForgetuser: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/get"
        
        let getuserrequest = GetUserRequest(token: token, id: id)
        let payloadJson = getuserrequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetuser(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForgetuser(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetuser(error)
                
            }
            
            
        }

    }
    
    static func getfeed(token: String, successCallbackForgetfeed: @escaping ([PostClass]) -> Void, errorCallbackForgetfeed: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "post/feed"
        
        let getfeedResquest = GetFeedRequest(token: token)
        let payloadJson = getfeedResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<PostClass>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetfeed(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForgetfeed(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetfeed(error)
                
            }
            
            
        }
        
        
    }
    
    
    
    static func changepassword(token: String, password: String, successCallbackForChangePassword: @escaping () -> Void, errorCallbackForChnagePassword: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/changePassword"
        
        let changePasswordRequest = ChangePasswordRequset(token: token, password: password)
        let payloadJson = changePasswordRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<ChangePasswordResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    successCallbackForChangePassword()
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForChnagePassword(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForChnagePassword(error)
                
            }
            
            
        }
        
        
    }
    
////////// relations
    
    
    static func follow(token: String, id: Int, successCallbackForFollow: @escaping (FollowResponse) -> Void, errorCallbackForFollow: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/relation/follow"
        
        let followrequest = FollowRequest(token: token, id: id)
        let payloadJson = followrequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<FollowResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForFollow(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForFollow(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForFollow(error)
                
            }        
            
        }
        
    }
      
    
    
    
    static func getCurrentUserFollowing(token: String, successCallbackForGetCurrentFolloing: @escaping ([Int]) -> Void, errorCallbackForGetCurrentFolloing: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/relation/getFollowing"
        
        let getCurrentUserFollowingResquest = GetCurrentUserFollowingRequest(token: token)
        let payloadJson = getCurrentUserFollowingResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArrayX<Int>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForGetCurrentFolloing(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForGetCurrentFolloing(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForGetCurrentFolloing(error)
                
            }
            
        }
        
    }
    
    
    
    static func isFollowing(token: String, id: Int, successCallbackForIsFollowing: @escaping (IsFollowingResponse) -> Void, errorCallbackForIsFollowing: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/relation/isFollowing"
        
        let isfollowingrequest = IsFollowingRequest(token: token, id: id)
        let payloadJson = isfollowingrequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<IsFollowingResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForIsFollowing(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForIsFollowing(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForIsFollowing(error)
                
            }
            
        }
        
    }
    
    
    
    
    static func unfollow(token: String, id: Int, successCallbackForUnfollow: @escaping (UnfollowResponse) -> Void, errorCallbackForUnfollow: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/relation/unfollow"
        
        let unfollowrequest = UnfollowRequest(token: token, id: id)
        let payloadJson = unfollowrequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<UnfollowResponse>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForUnfollow(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForUnfollow(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForUnfollow(error)
                
            }
            
        }
        
    }
    
    
    
    
    
}
