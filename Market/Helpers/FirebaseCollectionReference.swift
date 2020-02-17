//
//  FirebaseCollectionReference.swift
//  Market
//
//  Created by Hayden Frea on 14/07/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//
 
import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

