//
//  StripeClient.swift
//  Market
//
//  Created by Hayden Frea on 21/08/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let sharedClient = StripeClient()
    
    var baseURLString: String? = nil
    
    var baseURL: URL{
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            print(url)
            return url
        } else {
            fatalError()
        }
       
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping (_ error: Error?) -> Void) {
        
        let url = self.baseURL.appendingPathComponent("charge")
        print(url)
        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constats.defaultDescription, "currency" : Constats.defaultCurrency]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print(response)
                
                switch response.result {
                case .success( _):
                    print("Payment successful")
                    completion(nil)
                case .failure(let error):
                    //if (response.data?.count)! > 0 {print(error)}
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription)")
                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error: " + str)
                    }
                    debugPrint(error as Any)
                    print("===========================\n\n")
                    print("error processing the payment", error.localizedDescription)
                    completion(error)
                }
                
            })
      
        }
    }

