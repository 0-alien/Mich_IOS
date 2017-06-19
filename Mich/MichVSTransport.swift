//
//  MichVSTransport.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/7/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class MichVSTransport {
    
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

    static func invite(token: String, id: Int, successCallbackForinvite: @escaping () -> Void, errorCallbackForinvite: @escaping (DefaultError) -> Void) {
        
        let reqString = BASE_URL + "battle/invite"
        let getuserrequest = BattleInviteRequest(token: token, id: id)
        let payloadJson = getuserrequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<User>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForinvite()
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForinvite(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForinvite(error)
            }
        }
    }
    
    static func getBattles(token: String, successCallbackForGetBattles: @escaping ([Battle]) -> Void, errorCallbackForGetBattles: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "battle/getAll"
        let getBattlesRequest = GetBattlesRequest(token: token)
        let payloadJson = getBattlesRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponseArray<Battle>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    let res = baseResponse?.data
                    successCallbackForGetBattles(res!)
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetBattles(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetBattles(error)
            }
        }
    }
    
    static func getBattle(token: String, battleId: Int, successCallbackForGetBattle: @escaping (Battle) -> Void, errorCallbackForGetBattle: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "battle/get"
        let getBattleRequest = GetBattleRequest(token: token, battleId: battleId)
        let payloadJson = getBattleRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<Battle>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    let res = baseResponse?.data
                    successCallbackForGetBattle(res!)
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForGetBattle(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForGetBattle(error)
            }
        }
    }
    
    static func acceptBattle(token: String, battleId: Int, successCallbackForAcceptBattle: @escaping () -> Void, errorCallbackForAcceptBattle: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "battle/accept"
        let acceptBattleRequest = BattleActionRequest(token: token, battleId: battleId)
        let payloadJson = acceptBattleRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForAcceptBattle()
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForAcceptBattle(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForAcceptBattle(error)
            }
        }
    }
    static func declineBattle(token: String, battleId: Int, successCallbackForDeclineBattle: @escaping () -> Void, errorCallbackForDeclineBattle: @escaping (DefaultError) -> Void) {
        let reqString = BASE_URL + "battle/decline"
        let acceptBattleRequest = BattleActionRequest(token: token, battleId: battleId)
        let payloadJson = acceptBattleRequest.toJSONString()
        Alamofire.request(reqString, method: .post, parameters: [:], encoding: payloadJson!).responseString { response in
            if( response.result.isSuccess ){
                let JString = "\(response.result.value!)"
                print(JString)
                let baseResponse = BaseResponse<DummyMappable>(JSONString: JString)
                if baseResponse!.code! == SUCCESS_CODE {
                    successCallbackForDeclineBattle()
                }
                else {
                    print(baseResponse!.message!)
                    let error = DefaultError()
                    error.errorString = baseResponse!.message!
                    errorCallbackForDeclineBattle(error)
                }
            }
            else {
                let error = DefaultError()
                error.errorString = "Something went wrong!"
                errorCallbackForDeclineBattle(error)
            }
        }
    }
}
