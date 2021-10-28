//
//  ViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/22.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func goStartPlofileButton(_ sender: Any) {
        let startPlofilestoryboard = UIStoryboard(name: "StartPlofile", bundle: nil)
        guard let startPlofileViewController = startPlofilestoryboard.instantiateInitialViewController() as? StartPlofileViewController else {return}
        present(startPlofileViewController, animated: true)
    }
}

