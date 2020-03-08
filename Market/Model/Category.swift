//
//  Category.swift
//  Market
//
//  Created by Hayden Frea on 14/07/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download category from firebase

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
}

//MARK: Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}


//MARK: Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName!], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only one time
func createCategorySet() {

    let snacks = Category(_name: "Chips", _imageName: "snacksPicture")
    let candy = Category(_name: "Candy", _imageName: "snacksPicture")
    let drinks = Category(_name: "Drinks", _imageName: "drinksPicture")
    let toiletries = Category(_name: "Toiletries", _imageName: "ToiletriesPicture")
    let iceCream = Category(_name: "Ice Cream", _imageName: "iceCreamPicture")
    let liquor = Category(_name: "Alcohol", _imageName: "liquorPicture")
    let medicine = Category(_name: "Medicine", _imageName: "medicinePicture")
    let homeProducts = Category(_name: "Home Products", _imageName: "homePicture")
    let healthy = Category(_name: "Healthy", _imageName: "healthyPicture")
    let smoke = Category(_name: "Smokes", _imageName: "smokePicture")
    

    let arrayOfCategories = [snacks, drinks, toiletries, candy, iceCream, liquor, medicine, healthy, homeProducts, smoke]

    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }

}
