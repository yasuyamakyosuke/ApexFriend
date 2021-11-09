//
//  ListViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/27.
//

import UIKit
import Firebase
import Nuke

class ListViewController: UIViewController {
    var messagesListener: ListenerRegistration?
    var users : [String:User] = [:]
    var user : User?
    var messageSelectMode : String?
    var messages: [Message] = []
    var message : [String:Message] = [:]
    

    @IBOutlet weak var messageListTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messageListTableView.tableFooterView = UIView()
        messageListTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        userFirebase()
        
        
        
    }
    // ユーザーのデータを取るメソッド
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
                self.messageListTableView.reloadData()
            }
            
            listenMessages()
        }
    }
    func fetchUserIfNeed(userID: String) {
        if users[userID] != nil { return }
        
        let userRef = Firestore.firestore().collection("User").document(userID)
        
        userRef.getDocument { [self] (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                
                let name = data["name"] as? String
                let icon = data["icon"] as? String
                let id = document.documentID
                let mode = data["mode"] as? String
                let user = User(name: name, id: id, icon: icon, mode: mode)
                
                users[id] = user
                self.messageListTableView.reloadData()
                print(#line,users)
            }
        }
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
    
    // メッセージのデータをとってくるメソッド
    private func listenMessages() {
        
        if let messageListener = messagesListener {
            messagesListener?.remove()
            self.messagesListener = nil
        }
        
        let db = Firestore.firestore()
        guard let userSelectMode = user?.mode else { return }
        
        let ref = db.collection("messages").whereField("selectMode",isEqualTo: userSelectMode).order(by: "createdAt",descending: true)
        print(userSelectMode)
        messagesListener = ref.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
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
                print(#line,userID)
                messages.append(message)
            }
            self.messages = messages
            self.messageListTableView.reloadData()
            for message in messages {
                self.fetchUserIfNeed(userID: message.userID)
                
            }
        }
        
    }
    
    @IBAction func backSelectButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func recruitmentButton(_ sender: Any) {
        let recruitmentviewstoryboard = UIStoryboard(name: "Recruitment", bundle: nil)
        guard let recruitmentviewController = recruitmentviewstoryboard.instantiateInitialViewController() as? RecruitmentViewController else {return}
        present(recruitmentviewController, animated: true)
    }
}
extension ListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell",for: indexPath) as! ListTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分s秒"
        let dateString = dateFormatter.string(from: message.createdAt.dateValue())
        cell.createTimeLabel.text = dateString
        cell.titleText.text = message.title
        print(#line,users[message.userID])
        if let user = users[message.userID] {
            cell.userNameLabel.text = user.name
            if let icon = user.icon {
                Nuke.loadImage(with: URL(string: icon)!, into: cell.userIconImage)
            } else {
                cell.userIconImage.image = #imageLiteral(resourceName: "icon ")
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectMessage = messages[indexPath.row].id
        let selectUserID = messages[indexPath.row].id
        print(#line,selectMessage)
        let detailviewstoryboard = UIStoryboard(name: "Detail", bundle: nil)
        UserDefaults.standard.set(selectUserID, forKey: "userID")
        UserDefaults.standard.set(selectMessage, forKey: "id")
        guard let detailviewController = detailviewstoryboard.instantiateInitialViewController() as? DetailViewController else {return}
        present(detailviewController, animated: true)
    }
    
    
    
}


