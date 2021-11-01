//
//  StartPlofileViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class StartPlofileViewController: UIViewController {
    
    var users: [String: User] = [:]
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerPlofileButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        
        UserDefaults.standard.set(name, forKey: "userName")
        Auth.auth().signInAnonymously { [self] (result,error) in
            if error == nil{
                guard let user = result?.user else{
                    return}
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: "userID")
                let userData = User(name: name, id: userID, icon: nil, mode: nil)
                print(userData)
                let db = Firestore.firestore()
                db.collection("User").document(userData.id).setData(["name": userData.name as Any]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    
                }
            }
            
        }
        print(#line)
        let selectModestoryboard = UIStoryboard(name: "SelectMode", bundle: nil)
        guard let selectModeView = selectModestoryboard.instantiateInitialViewController() as? SelectModeViewController else {return}
        present(selectModeView, animated: true)
        
    }
}
