//
//  ListViewController.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/10/27.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backSelectButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
         
    }
    
    @IBAction func recruitmentButton(_ sender: Any) {
        let recruitmentviewstoryboard = UIStoryboard(name: "Recruitment", bundle: nil)
        guard let recruitmentviewController = recruitmentviewstoryboard.instantiateInitialViewController() as? RecruitmentViewController else {return}
        present(recruitmentviewController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
