//
//  RecruitmentViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/11/01.
//

import UIKit
import Firebase

class RecruitmentViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var selectPlatform:String?
    var selectNumber:String?
    var selectFirstChara:String?
    var selectSecondChara:String?
    var  user: User?
    var selectMode:String?
    
    @IBOutlet weak var platformPicker: UIPickerView!
    
    @IBOutlet weak var numberPicker: UIPickerView!
    
    @IBOutlet weak var firstChoicePicker: UIPickerView!
    
    @IBOutlet weak var secondChoicePicker: UIPickerView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var vcTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    var platform = ["PC","PS","switch","xbox"]
    let number = ["1","2"]
    let firstcharaname = ["なし","レイス","ジブラルタル","オクタン","パスファインダー","8","9","10"]
    
    let secondcharaname = ["なし","レイス","ジブラルタル","オクタン","パスファインダー","8","9","10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#line)
        platformPicker.delegate = self
        platformPicker.dataSource = self
        numberPicker.delegate = self
        numberPicker.dataSource = self
        firstChoicePicker.delegate = self
        firstChoicePicker.dataSource = self
        secondChoicePicker.delegate = self
        secondChoicePicker.dataSource = self
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return platform.count
        } else if pickerView.tag == 2 {
            return number.count
        } else if pickerView.tag == 3 {
            return firstcharaname.count
        } else {
            return secondcharaname.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return platform[row]
        } else if pickerView.tag == 2 {
            return number[row]
        } else if pickerView.tag == 3{
            return firstcharaname[row]
        } else {
            return secondcharaname[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            let selectPlatform = platform[row]
            self.selectPlatform = selectPlatform
        } else if pickerView.tag == 2 {
            let selectNumber = number[row]
            self.selectNumber = selectNumber
        } else if pickerView.tag == 3 {
            let selectFirstChara = firstcharaname[row]
            self.selectFirstChara = selectFirstChara
        } else {
            let selectSecondChara = secondcharaname[row]
            self.selectSecondChara = selectSecondChara
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recruitmentButton(_ sender: Any) {
        userFirebase()
    }
    func userFirebase() {
        print(#line)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("User").document(uid)
        userRef.getDocument { [self] (document, _) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:))  ?? "nil"
                guard let data = document.data() else { return }
                let name = data["name"] as? String
                let icon = data["icon"] as? String
                let mode = data["mode"] as? String
                let id = document.documentID
                let user = User(name: name, id: id, icon: icon, mode: mode)
                self.selectMode = user.mode
                
                
            }
            recruitmentStart()
        }
    }
    func recruitmentStart(){
        guard let time = timeTextField.text else { return }
        guard let vc = vcTextField.text else { return }
        if self.selectPlatform == nil {
            self.selectPlatform = "PC"
            print(#line)
        }
        if self.selectFirstChara == nil {
            self.selectFirstChara = "なし"
        }
        if self.selectSecondChara == nil {
            self.selectSecondChara = "なし"
        }
        guard let selectPlatform = self.selectPlatform else
        { return }
        guard let selectNumber = self.selectNumber else { return }
        let selectFirstChara = self.selectFirstChara
        let selectSecondChara = self.selectSecondChara
        let title = titleTextField.text
        let selectMode = self.selectMode
        
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "title":title as Any,
            "userID": userID,
            "time": time,
            "selectPlatform": selectPlatform,
            "selectNumber": selectNumber,
            "vc":vc,
            "selectFirstChara":selectFirstChara as Any,
            "selectSecondChara":selectSecondChara as Any,
            "selectMode":selectMode as Any,
            "createdAt": Timestamp()
        ]
        print(data)
        
        db.collection("messages").addDocument(data: data)
        dismiss(animated: true, completion: nil)
        print(#line)
    }
    
    
    
}
