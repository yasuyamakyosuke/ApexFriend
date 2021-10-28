//
//  SelectModeViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/27.
//

import UIKit

class SelectModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print()

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
    
}
