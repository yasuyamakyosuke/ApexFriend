//
//  SelectModeViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/27.
//

import UIKit
import Firebase

class SelectModeViewController: UIViewController {
    
    var mode:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print()

    }
    func selectMode(){
        let mode = self.mode
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData = ["mode":mode]
        let userRef = Firestore.firestore().collection("User").document(uid)
        userRef.setData(docData as [String : Any], merge: true) { (err) in
            if let err = err {
                print("\(err)")
                return
            }
            print("Firestoreに保存に成功しました。")
        }
    }
    
    @IBAction func goListButton(_ sender: Any) {
        let liststoryboard = UIStoryboard(name: "List", bundle: nil)
        guard let listView = liststoryboard.instantiateInitialViewController() as? ListViewController else {return}
        present(listView, animated: true)
    }
    
    @IBAction func goEditPlofileButton(_ sender: Any) {
        let liststoryboard = UIStoryboard(name: "EditPlofile", bundle: nil)
        guard let editPlofileView = liststoryboard.instantiateInitialViewController() as? EditPlofileViewController else {return}
        present(editPlofileView, animated: true)
    }
    
    @IBAction func gocasualButton(_ sender: Any) {
        let mode = "casual"
        self.mode = mode
        selectMode()

        let listviewstoryboard = UIStoryboard(name: "List", bundle: nil)
        guard let listviewController = listviewstoryboard.instantiateInitialViewController() as? ListViewController else {return}
        present(listviewController, animated: true)
    }
    
    @IBAction func goOneononeButton(_ sender: Any) {
        let mode = "Oneonone"
        self.mode = mode
        selectMode()
        let listviewstoryboard = UIStoryboard(name: "List", bundle: nil)
        guard let listviewController = listviewstoryboard.instantiateInitialViewController() as? ListViewController else {return}
        present(listviewController, animated: true)
        
    }
    
}
