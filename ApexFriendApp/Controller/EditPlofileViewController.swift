//
//  EditPlofileViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/28.
//

import UIKit
import Firebase
import FirebaseFirestore
import Nuke

class EditPlofileViewController: UIViewController {
    
    var users: User?
    
    
    @IBOutlet weak var userIconImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userFirebase()
        if let icon = users?.icon {
            Nuke.loadImage(with: URL(string: icon)!, into: userIconImage)
        } else {
            userIconImage.image = #imageLiteral(resourceName: "icon ")
        }
        userIconImage.layer.cornerRadius = userIconImage.bounds.height/2
        userIconImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func userFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Firestore.firestore().collection("User").document(uid)
        userRef.getDocument { [self] (document, error ) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data()  else { return }
                let name = data["name"] as? String
                let id = document.documentID
                let user = User(name:name, id:id, icon: nil)
                self.users = user
                print(user)
                userNameLabel.text = user.name
            }
        }
    }
    

}
