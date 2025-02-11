//
//  MUser.swift
//  Market
//
//  Created by Hayden Frea on 01/08/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser {
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    var phoneNumber: String
    var zipCode: String
    
    var fullAddress: String?
    var onBoard: Bool
    
    
    //MARK: - Initializers
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String, _phoneNumber: String, _zipCode: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        phoneNumber = _phoneNumber
        zipCode = _zipCode
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
    }

    init(_dictionary: NSDictionary) {
        
       objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
            firstName = fname as! String
        } else {
            firstName = ""
        }
        if let lname = _dictionary[kLASTNAME] {
            lastName = lname as! String
        } else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
            fullAddress = faddress as? String
        } else {
           fullAddress = ""
        }
        
        
        if let pnumber = _dictionary[kPHONENUMBER] {
            phoneNumber = pnumber as! String
        } else {
           phoneNumber = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
           onBoard = onB as! Bool
         } else {
           onBoard = false
         }

         if let purchaseIds = _dictionary[kPURCHASEDITEMIDS] {
          purchasedItemIds = purchaseIds as! [String]
        } else {
          purchasedItemIds = []
        }
        
        if let zcode = _dictionary[kZIPCODE] {
            zipCode = zcode as! String
        } else {
            zipCode = ""
        }
        
       
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
    
    class func currentUser() -> MUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return MUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    
                    print("email is not verified")
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
        }
    }

    
    //MARK: - Register user
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error : ", error?.localizedDescription as Any)
                }
            }
        }
    }

    
    //MARK: - Resend link methods

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(" resend email error: ", error?.localizedDescription as Any)
                
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
        
        
    }

}//end of class

//MARK: - DownloadUser

func downloadUserFromFirestore(userId: String, email: String) {
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        } else {
            //there is no user, save new in firestore
            
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "", _phoneNumber: "", _zipCode: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
    }
    

}





//MARK: - Save user to firebase

func saveUserToFirestore(mUser: MUser) {
    
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String : Any]) { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}


func saveUserLocally(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: - Helper Function

func userDictionaryFrom(user: MUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress!, user.phoneNumber, user.onBoard, user.purchasedItemIds, user.zipCode], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kPHONENUMBER as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying, kZIPCODE as NSCopying])
}

//MARK: - Update user

func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(MUser.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}

