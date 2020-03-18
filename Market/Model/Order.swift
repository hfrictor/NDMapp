//
//  Order.swift
//  Market
//
//  Created by Hayden Frea on 2/22/20.
//  Copyright © 2020 Hayden Frea. All rights reserved.
//

import Foundation


class Order {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    var name: String!
    var address: String!
    var zipCode: String!
    var phoneNumber: String!
    var myEmail: String!
    var myMessage: String!
    var mySubject: String!
    var isCompleted: Bool!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
        name = _dictionary[kFULLNAME] as? String
        address = _dictionary[kFULLADDRESS] as? String
        zipCode = _dictionary[kZIPCODE] as? String
        phoneNumber = _dictionary[kPHONENUMBER] as? String
        myEmail = _dictionary[kMYEMAIL] as? String
        myMessage = _dictionary[kMYMESSAGE] as? String
        mySubject = _dictionary[kMYSUBJECT] as? String
        isCompleted = _dictionary[kISCOMPLETED] as? Bool ?? false
    }
}


//MARK: - Download items
func downloadOrderFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Order?)-> Void) {
    
    FirebaseReference(.Order).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let order = Order(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(order)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveOrderToFirestore(_ order: Order) {
    
    FirebaseReference(.Order).document(order.id).setData(orderDictionaryFrom(order) as! [String: Any])
}


//MARK: Helper functions

func orderDictionaryFrom(_ order: Order) -> NSDictionary {
    
    return NSDictionary(objects: [order.id!, order.ownerId!, order.itemIds!, order.name!, order.address!, order.zipCode ?? "0000" , order.phoneNumber!, order.myEmail ?? "haydenfrea@gmail.com", order.myMessage!, order.mySubject!, order.isCompleted!], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kZIPCODE as NSCopying, kPHONENUMBER as NSCopying, kMYEMAIL as NSCopying, kMYMESSAGE as NSCopying, kMYSUBJECT as NSCopying, kISCOMPLETED as NSCopying])
}

//MARK: - Update Order
func updateOrderInFirestore(_ order: Order, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Order).document(order.id).updateData(withValues) { (error) in
        completion(error)
    }
}
