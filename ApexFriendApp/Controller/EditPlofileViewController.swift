//
//  EditPlofileViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/28.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import Nuke
import FirebaseStorage

class EditPlofileViewController: UIViewController {
    
    var users: User?
    var selectedImage: UIImage?
    var iconListener: ListenerRegistration?
    
    
    @IBOutlet weak var userIconImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userFirebase()
        listnerIcon()
        if let icon = users?.icon {
            Nuke.loadImage(with: URL(string: icon)!, into: userIconImage)
        } else {
            userIconImage.image = #imageLiteral(resourceName: "icon ")
        }
        userIconImage.layer.masksToBounds = false
        userIconImage.layer.cornerRadius = userIconImage.bounds.height/2
        userIconImage.clipsToBounds = true
        userIconImage.backgroundColor = .red

        // Do any additional setup after loading the view.
    }
    
    
    func listnerIcon(){
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        iconListener = db.collection("User").document(uid).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                return
            }
            let data = document.data()
            if let icon = data?["icon"]as? String {
                let url = URL(string: icon)!
                Nuke.loadImage(with: url, into: userIconImage)
            }
            if let name = data?["name"]as? String {
                userNameLabel.text = name
            }
        }
            
            
    }
    
    func userFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Firestore.firestore().collection("User").document(uid)
        userRef.getDocument { [self] (document, error ) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data()  else { return }
                let name = data["name"] as? String
                let icon = data["icon"] as? String
                let id = document.documentID
                let user = User(name:name, id:id, icon: icon)
                self.users = user
                print(user)
                userNameLabel.text = user.name
            }
        }
    }
    func imageSelect() {
        let imagePickerController = UIImagePickerController()
        print(#line)
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func nameEdit() {
        let alert = UIAlertController(title: "名前の変更", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {(_) in
            if let textField = alert.textFields?.first {
                guard let name = textField.text else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let docData = ["name":name]
                let userRef = Firestore.firestore().collection("User").document(uid)
                userRef.setData(docData, merge: true) { (err) in
                    if let err = err {
                        print("名前の保存に失敗しました。\(err)")
                        return
                    }
                    print("Firestoreに保存に成功しました。")
                }
            }
        }
        alert.addAction(okButton)
        let cancelButton = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    func imageEdit() {
        let alert = UIAlertController(title: "アイコンの変更", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "ライブラリ", style: .default) { [weak self]  _ in
            print("--1--")
            self?.imageSelect()
            print("--2--")
            self?.userImageRegister()
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    private func userImageRegister() {
        print("--3--")
        print(selectedImage)
        guard let image = selectedImage else { return }
        print("--4--")
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else {
            return }
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: "gs://apexfriendapp.appspot.com")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageRef = storageRef.child("User/\(uid)/icon")
        imageRef.putData(uploadImage, metadata: nil) { (_, error) in
            if let error = error {
                print("画像が保存できませんでした",error)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                print("--4--")
                if let error = error {
                    print(error.localizedDescription)
                }
                if let url = url {
                    let docData = ["icon":url.absoluteString]
                    let userRef = Firestore.firestore().collection("User").document(uid)
                    userRef.setData(docData, merge: true) { (err) in
                        if let err = err {
                            print("画像 guard let uid = Auth.auth().currentUser?.uid else { return }の保存に失敗しました。\(err)")
                            return
                        }
                        print("--5--")
                    }
                }
            }
        }
        

    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}


extension EditPlofileViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath)
        tableView.tableFooterView = UIView()
        if indexPath.row == 0 {
            cell.textLabel?.text = "アイコンの変更"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "ユーザー名の変更"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "お問い合わせ"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            imageEdit()
        } else if indexPath.row == 1 {
            nameEdit()
        } else if indexPath.row == 2 {
            
        }
    }
    
    
    
}

extension EditPlofileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#line)
        if let editImage = info[.editedImage] as? UIImage {
            selectedImage = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        print(#line)
        }
        print(#line)
        userImageRegister()
        dismiss(animated: true, completion: nil)
    }
}
