//
//  DetailViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/11/04.
//

import UIKit
import Firebase
import IoniconsKit

class DetailViewController: UIViewController {
    
    var user:User?
    var message : [String:Message] = [:]
    var selectMessage:Message?
    var users : [String:User] = [:]
    var selectMessageID = UserDefaults.standard.string(forKey: "id")
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIconImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var replyText: UITextView!
    
 
    @IBOutlet weak var replyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenMessages()
        replyText.layer.borderWidth = 2.0
        replyText.layer.cornerRadius = 10.0
        let imageIcon = UIImage.ionicon(with: .androidSend, textColor: UIColor.gray, size: CGSize(width: 24, height: 24))
        replyButton.setImage(imageIcon, for: .normal)
        print(#line,selectMessage?.title)
        
    }
    func fetchUserIfNeed() {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let userRef = Firestore.firestore().collection("User").whereField("uid", isEqualTo: userID).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("\(err)")
            } else {
                for document in  querySnapshot!.documents {
                    let data = document.data()
                    
                    let name = data["name"] as? String
                    let icon = data["icon"] as? String
                    let id = document.documentID
                    let mode = data["mode"] as? String
                    let user = User(name: name, id: id, icon: icon, mode: mode)
                    
                    self.users[id] = user
                    print(#line,users)
                }
            }
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if !replyText.isFirstResponder {
            return
        }
    
        if self.view.frame.origin.y == 0 {
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardRect.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        replyText.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func userFirebase() {
        print(#line)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Firestore.firestore().collection("User").document(uid)
        userRef.getDocument { [self] (document, error ) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data()  else { return }
                let name = data["name"] as? String
                let icon = data["icon"] as? String
                let mode = data["mode"] as? String
                let id = document.documentID
                let user = User(name:name, id:id, icon: icon, mode: mode)
                self.user = user
                print(#line,user)
            }
        }
    }
    private func listenMessages() {
        
        let db = Firestore.firestore()
        let ref = db.collection("messages")
        ref.getDocuments(completion: { [self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(#line,"Error fetching documents: \(error!)")
                return
            }
            var messages = [Message]()
            for document in documents {
                let data = document.data()
                let selectMode = data["selectMode"] as! String
                let selectNumber = data["selectNumber"] as! String
                let selectPlatform = data["selectPlatform"] as! String
                let selectFirstChara = data["selectFirstChara"] as! String
                let selectSecondChara = data["selectSecondChara"] as! String
                let time = data["time"] as? String
                let title = data["title"] as? String
                let userID = data["userID"] as! String
                let vc = data["vc"] as? String
                let createdAt = data["createdAt"] as! Timestamp
                let message = Message(id:document.documentID,selectMode: selectMode, selectNumber: selectNumber, selectPlatform: selectPlatform, selectFirstChara: selectFirstChara, selectSecondChara: selectSecondChara, time: time, title: title, userID: userID, vc: vc, createdAt: createdAt)
                if message.id == selectMessageID {
                    self.selectMessage = message
                    print(#line,self.selectMessage)
                    self.titleLabel.reloadInputViews()
                }
                titleLabel.text = selectMessage?.title
            }
        })
        }
    func messageIdNeed(id:String) {
        if message[id] != nil { return }
        let messageRef = Firestore.firestore().collection("Message").document(id)
        messageRef.getDocument { [self] (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let selectMode = data["selectMode"] as! String
                let selectNumber = data["selectNumber"] as! String
                let selectPlatform = data["selectPlatform"] as! String
                let selectFirstChara = data["selectFirstChara"] as! String
                let selectSecondChara = data["selectSecondChara"] as! String
                let time = data["time"] as? String
                let title = data["title"] as? String
                let userID = data["userID"] as! String
                let vc = data["vc"] as? String
                let createdAt = data["createdAt"] as! Timestamp
                let message = Message(id:document.documentID,selectMode: selectMode, selectNumber: selectNumber, selectPlatform: selectPlatform, selectFirstChara: selectFirstChara, selectSecondChara: selectSecondChara, time: time, title: title, userID: userID, vc: vc, createdAt: createdAt)
                self.message[id] = message
            }
        }
    }
//    func messageIdNeed() {
//        print("--メソッドスタート--")
//        let userID = UserDefaults.standard.string(forKey: "userID")
//        print(userID)
//        let messageRef = Firestore.firestore().collection("Message").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                print(#line)
//                // 82行目の処理で止まってしまう
//                for document in  querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    let data = document.data()
//                    print(#line)
//                    print(#line)
//                    let selectMode = data["selectMode"] as! String
//                    let selectNumber = data["selectNumber"] as! String
//                    let selectPlatform = data["selectPlatform"] as! String
//                    let selectFirstChara = data["selectFirstChara"] as! String
//                    let selectSecondChara = data["selectSecondChara"] as! String
//                    let time = data["time"] as? String
//                    let title = data["title"] as? String
//                    let userID = data["userID"] as! String
//                    let vc = data["vc"] as? String
//
//                    let createdAt = data["createdAt"] as! Timestamp
//                    let message = Message(id:document.documentID,selectMode: selectMode, selectNumber: selectNumber, selectPlatform: selectPlatform, selectFirstChara: selectFirstChara, selectSecondChara: selectSecondChara, time: time, title: title, userID: userID, vc: vc, createdAt: createdAt)
//                    print(#line,message)
//                    self.selectMessage = message
//
//                }
//            }
//        }
//    }
//
}
