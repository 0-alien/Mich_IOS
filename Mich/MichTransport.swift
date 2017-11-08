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
    static let BAN_WORD = 27
    
    
    
    static func defaultLogin(username: String, password: String, successCallback: @escaping (String) -> Void, errorCallback: @escaping (DefaultError) -> Void ){
    
        let reqString = BASE_URL + "auth/login"
        let loginRequest = LoginRequest(username: username, password:password, type: 0)
        let payloadJson = loginRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
//           print(response.request)  // original URL request
//           print(response.response) // HTTP URL response
//           print(response.data)     // server data
//           print(response.result)   // result of response serialization
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseX<String>(JSONString: JString)
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
    
    static func register(username:String, email: String, password: String, name: String, dateOfBirth:String, placeOfBirth:String, successCallbackForRegister: @escaping () -> Void, errorCallbackForRegister: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "auth/register"
        let registerRequest = RegisterRequest(username:username, email: email,password:password,name:name, dateOfBirth:dateOfBirth, placeOfBirth:placeOfBirth)
        let payloadJson = registerRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
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
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
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
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
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
        
        print("_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+")
        let reqString = BASE_URL + "auth/logout"
        let logoutResquest = LogoutRequest(token: token)
        let payloadJson = logoutResquest.toJSONString()
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                
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
    
    static func changepassword(token: String, password: String, oldPassword:String, successCallbackForChangePassword: @escaping () -> Void, errorCallbackForChnagePassword: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "user/changePassword"
        let changePasswordRequest = ChangePasswordRequset(token: token, password: password, oldPassword:oldPassword)
        let payloadJson = changePasswordRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
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
    
    ////// done
    
    static func like(token: String, postID: Int, successCallbackForLike: @escaping () -> Void, errorCallbackForLike: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/like"
        let likeRequest = LikeRequest(token: token, postID: postID)
        let payloadJson = likeRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForLike()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForLike(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForLike(error)
                
            }
        }
    }
    
    
    ////// done
    static func unlike(token: String, postID: Int, successCallbackForUnlike: @escaping () -> Void, errorCallbackForUnlike: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/unlike"
        let unlikeRequest = UnlikeRequest(token: token, postID: postID)
        let payloadJson = unlikeRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForUnlike()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForUnlike(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForUnlike(error)
            }
        }
    }
    
////////// relations
    //////////// done
    static func follow(token: String, id: Int, successCallbackForFollow: @escaping () -> Void, errorCallbackForFollow: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "user/relation/follow"
        let followrequest = FollowRequest(token: token, id: id)
        let payloadJson = followrequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForFollow()
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
    
    ///////////// ????????????
    
    static func getCurrentUserFollowing(token: String, successCallbackForGetCurrentFolloing: @escaping ([User]) -> Void, errorCallbackForGetCurrentFolloing: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "user/relation/getFollowing"
        let getCurrentUserFollowingResquest = GetCurrentUserFollowingRequest(token: token)
        let payloadJson = getCurrentUserFollowingResquest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<User>(JSONString: JString)
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
    
    ////////// ???????????????
    static func getCurrentUserFollowers(token: String, successCallbackForGetCurrentFollowers: @escaping ([User]) -> Void, errorCallbackForGetCurrentFollowers: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/relation/getFollowers"
        
        let getCurrentUserFollowersResquest = GetCurrentUserFollowersRequest(token: token)
        let payloadJson = getCurrentUserFollowersResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForGetCurrentFollowers(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForGetCurrentFollowers(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForGetCurrentFollowers(error)
                
            }
            
        }
        
    }

    ////// getusersfolloers ??????????????????
   
    static func getUserFollowers(token: String, id: Int, successCallbackForGetFollowers: @escaping ([User]) -> Void, errorCallbackForGetFollowers: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/relation/getFollowers"
        
        let getUserFollowersResquest = GetUsersFollowersRequest(token: token, id: id)
        let payloadJson = getUserFollowersResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForGetFollowers(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForGetFollowers(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForGetFollowers(error)
                
            }
            
        }
        
    }
    
    
    //////// get users folloing ????????????????
    
    static func getUserFollowing(token: String, id: Int, successCallbackForGetFollowing: @escaping ([User]) -> Void, errorCallbackForGetFollowing: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/relation/getFollowing"
        
        let getUserFollowingResquest = GetUsersFollowingRequest(token: token, id: id)
        let payloadJson = getUserFollowingResquest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForGetFollowing(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForGetFollowing(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForGetFollowing(error)
                
            }
            
        }
        
    }
    
    ///////// done
    static func isFollower(token: String, id: Int, successCallbackForIsFollower: @escaping (IsFollowerResponse) -> Void, errorCallbackForIsFollower: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "user/relation/isFollower"
        let isfollowerrequest = IsFollowerRequest(token: token, id: id)
        let payloadJson = isfollowerrequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<IsFollowerResponse>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    let res = baseResponse!.data!
                    successCallbackForIsFollower(res)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForIsFollower(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForIsFollower(error)
            }
        }
    }
    
    ////////// done
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
    
    ////////// done
    
    static func unfollow(token: String, id: Int, successCallbackForUnfollow: @escaping () -> Void, errorCallbackForUnfollow: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/relation/unfollow"
        
        let unfollowrequest = UnfollowRequest(token: token, id: id)
        let payloadJson = unfollowrequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                   
                    successCallbackForUnfollow()
                    
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
    
    //////////// posts
    
    
    static func createpost(token: String, title: String, image: UIImage, successCallbackForCreatePost: @escaping () -> Void, errorCallbackForCreatePost: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/create"
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.3)! as NSData
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        //print(strBase64)
        let createpostRequest = CreatePostRequest(token: token, title: title, image: strBase64)
        let payloadJson = createpostRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForCreatePost()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForCreatePost(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForCreatePost(error)
            }
        }
    }

    static func addcomment(token: String, postID: Int, comment: String, successCallbackForAddComment: @escaping (Comment) -> Void, errorCallbackForAddComment: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/comment"
        let addcommentRequest = AddCommentRequest(token: token, postID: postID, comment: comment)
        let payloadJson = addcommentRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<Comment>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForAddComment((baseResponse?.data)!)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForAddComment(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForAddComment(error)
            }
        }
    }
    
    /////////////// search users
    static func searchusers(token: String, term: String, successCallbackForsearchusers: @escaping ([User]) -> Void, errorCallbackForsearchusers: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "search/users/"
        let searchusersResquest = SearchUsersRequest(token: token, term: term)
        let payloadJson = searchusersResquest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<User>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    let res = baseResponse!.data!
                    successCallbackForsearchusers(res)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForsearchusers(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForsearchusers(error)
            }
        }
    }

    
    /////////////////
    static func getuserposts(token: String, id: Int, successCallbackForgetuserposts: @escaping ([PostClass]) -> Void, errorCallbackForgetuserposts: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/posts"
        
        let getuserpostsResquest = GetUserPostsRequest(token: token, id: id)
        let payloadJson = getuserpostsResquest.toJSONString()
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<PostClass>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetuserposts(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForgetuserposts(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetuserposts(error)
                
            }
            
            
        }
        
        
    }
    
    static func getpostcomments(token: String, id: Int, successCallbackForgetuserposts: @escaping ([Comment]) -> Void, errorCallbackForgetuserposts: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "post/comments"
        
        let getPostCommentsRequest = GetPostCommentsRequest(token: token, id: id)
        let payloadJson = getPostCommentsRequest.toJSONString()
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<Comment>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetuserposts(res)
                    
                }else{ 
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForgetuserposts(error)
                }
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetuserposts(error)
                
            }
            
            
        }
        
        
    }

    static func getpost(token: String, id: Int, successCallbackForgetpost: @escaping (PostClass) -> Void, errorCallbackForgetpost: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "post/get"
        
        let getPostCommentsRequest = GetPostCommentsRequest(token: token, id: id)
        let payloadJson = getPostCommentsRequest.toJSONString()
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<PostClass>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForgetpost(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForgetpost(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForgetpost(error)
                
            }
            
            
        }
        
        
    }
    
    
    
    ///////////////////// get random post
    
    static func getrandompost(token: String, successCallbackGetRandomPost: @escaping (PostClass) -> Void, errorCallbackGetRandomPost: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/random"
        
        let getRandomPostRequest = GetRandomPost(token: token)
        let payloadJson = getRandomPostRequest.toJSONString()
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<PostClass>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {

                    let res = baseResponse!.data!
                    successCallbackGetRandomPost(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    errorCallbackGetRandomPost(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackGetRandomPost(error)
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    static func explore(token: String, successCallbackForexplore: @escaping ([PostClass]) -> Void, errorCallbackForexplore: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "post/explore"
        
        let exploreRequest = GetCurrentUserRequest(token: token)
        let payloadJson = exploreRequest.toJSONString()
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<PostClass>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForexplore(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForexplore(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForexplore(error)
                
            }
            
        }
        
    }
    
    
    static func updateUser(token: String?, name: String?, username: String?, email: String?, avatar: UIImage?, successCallbackForUpdateUser: @escaping (User) -> Void, errorCallbackForUpdateUser: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "user/update"
        var strBase64:String = ""
        
        
        if(avatar != nil){
            let imageData:NSData = UIImageJPEGRepresentation(avatar!, 0.1)! as NSData
            strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
        let updateuserRequest = UpdateUserRequest(token: token!, name: name!, username:username!, email: email!, avatar: strBase64)
        let payloadJson = updateuserRequest.toJSONString()
        

        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<User>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    let res = baseResponse!.data!
                    successCallbackForUpdateUser(res)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForUpdateUser(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForUpdateUser(error)
                
            }
            
            
        }
        
    }
    
    
    static func deletepost(token: String, postID: Int,  successCallbackForDeletePost: @escaping (Int) -> Void, errorCallbackForDeletePost: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "post/delete"
        
        let deltepostRequest = DeletePostRequest(token: token, postID: postID)
        let payloadJson = deltepostRequest.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    successCallbackForDeletePost(postID)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForDeletePost(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForDeletePost(error)
                
            }
            
        }
        
    }
    
    static func likecomment(token: String, commentID: Int,  successCallbackForLikeComment: @escaping (Int) -> Void, errorCallbackForLikeComment: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "comment/like"
        
        let likecomment = LikeCommentRequest(token: token, commentID: commentID)
        let payloadJson = likecomment.toJSONString()
        
        
        
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            
            
            if( response.result.isSuccess ){
                
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                
                if baseResponse!.code! == SUCCESS_CODE {
                    
                    
                    successCallbackForLikeComment(commentID)
                    
                }else{
                    
                    print(baseResponse!.message!)
                    
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    
                    
                    errorCallbackForLikeComment(error)
                    
                }
                
                
            }else{
                
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                
                
                errorCallbackForLikeComment(error)
                
            }
            
        }
        
    }

    static func unlikecomment(token: String, commentID: Int,  successCallbackForUnLikeComment: @escaping (Int) -> Void, errorCallbackForUnLikeComment: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "comment/unlike"
        let unlikecomment = UnlikeCommentRequest(token: token, commentID: commentID)
        let payloadJson = unlikecomment.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForUnLikeComment(commentID)
                }else{                    
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForUnLikeComment(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForUnLikeComment(error)
            }
        }
    }
    
    static func hidepost(token: String, postID: Int,  successCallbackForHidePost: @escaping (Int) -> Void, errorCallbackForHidePost: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/hide"
        let hidepostRequest = HidePostRequest(token: token, postID: postID)
        let payloadJson = hidepostRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForHidePost(postID)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForHidePost(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForHidePost(error)
            }
        }
    }

    static func getAllNotifications(token: String, successCallbackForHidePost: @escaping ([MichNotification]) -> Void, errorCallbackForHidePost: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "notification/getAll"
        let getNotificationsRequest = LogoutRequest(token: token)
        let payloadJson = getNotificationsRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<MichNotification>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForHidePost((baseResponse?.data)!)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForHidePost(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForHidePost(error)
            }
        }
    }
    
    static func deletecomment(token: String, commentID: Int,  successCallbackForDeleteComment: @escaping (Int) -> Void, errorCallbackForDeleteComment: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/deleteComment"
        let deletecomment = DeleteCommentRequest(token: token, commentID: commentID)
        let payloadJson = deletecomment.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForDeleteComment(commentID)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForDeleteComment(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForDeleteComment(error)
            }
        }
    }
    
    static func socialShare(token: String, postID: Int,  successCallbackForSocialShare: @escaping (SocialResponse) -> Void, errorCallbackForSocialShare: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "social/share"
        let socialShareRequest = SocialRequest(token: token, postID: postID)
        let payloadJson = socialShareRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<SocialResponse>(JSONString: JString)
                let res = baseResponse!.data!
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForSocialShare(res)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForSocialShare(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForSocialShare(error)
            }
        }
    }
    
    
    static func reportpost(token: String, postID: Int, successCallbackForReportPost: @escaping () -> Void, errorCallbackForReportPost: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "post/report"
        let reportpost = ReportPostRequest(token: token, postID: postID)
        let payloadJson = reportpost.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForReportPost()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForReportPost(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForReportPost(error)
            }
        }
    }
    
    static func reportcomment(token: String, commentID: Int,  successCallbackForReportComment: @escaping (Int) -> Void, errorCallbackForReportComment: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "comment/report"
        let reportcomment = ReportCommentRequest(token: token, commentID: commentID)
        let payloadJson = reportcomment.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForReportComment(commentID)
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForReportComment(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForReportComment(error)
            }
        }
    }
    
    static func reportuser(token: String, userID: Int,  successCallbackForReportUser: @escaping () -> Void, errorCallbackForReportUser: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "user/report"
        let reportuser = ReportUserRequest(token: token, id: userID)
        let payloadJson = reportuser.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForReportUser()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForReportUser(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForReportUser(error)
            }
        }
    }
    
    static func blockuser(token: String, userID: Int,  successCallbackForBlockUser: @escaping () -> Void, errorCallbackForBlockUser: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "user/block"
        let blockuser = BlockUserRequest(token: token, id: userID)
        let payloadJson = blockuser.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForBlockUser()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForBlockUser(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForBlockUser(error)
            }
        }
    }
    
    static func unblockuser(token: String, userID: Int,  successCallbackForUnBlockUser: @escaping () -> Void, errorCallbackForUnBlockUser: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "user/unblock"
        let unblockuser = UnblockUserRequest(token: token, id: userID)
        let payloadJson = unblockuser.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForUnBlockUser()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForUnBlockUser(error)
                }
            }else{
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForUnBlockUser(error)
            }
        }
    }
    
    static func askQuestion(question: String,  successCallbackForAskQuestion: @escaping () -> Void, errorCallbackForAskQuestion: @escaping (DefaultError) -> Void ){
        let reqString = BASE_URL + "faq/ask"
        let aksquestion = AskQuestionRequest(question: question)
        let payloadJson = aksquestion.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForAskQuestion()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForAskQuestion(error)
                }
            } else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForAskQuestion(error)
            }
        }
    }
    
    //////// piriqit aris mgoni severze
    static func togglePrivacyStatus(token: String,  successCallbackForTogglePrivacyStatus: @escaping () -> Void, errorCallbackForTogglePrivacyStatus: @escaping (DefaultError) -> Void ){
        
        let reqString = BASE_URL + "user/toggleStatus"
        
        let toggleprivacystatus = TogglePrivacyStatusRequest(token: token)
        let payloadJson = toggleprivacystatus.toJSONString()
   
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForTogglePrivacyStatus()
                }else{
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForTogglePrivacyStatus(error)
                }
            } else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForTogglePrivacyStatus(error)
            }
        }
    }
    
    
    static func updateFirebaseToken(token: String, firToken: String, successCallbackForGetBattles: @escaping () -> Void, errorCallbackForGetBattles: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "fcm/update"
        let updateFirebaseTokenRequest = UpdateFirebaseTokenRequest(token: token, fireBaseToken: firToken)
        let payloadJson = updateFirebaseTokenRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForGetBattles()
                } else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetBattles(error)
                }
            } else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetBattles(error)
            }
        }
    }
    
}
