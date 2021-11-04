//
//  ListTableViewCell.swift
//  ApexFriendApp
//
//  Created by 泰山恭輔 on 2021/11/04.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userIconImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var commentImage: UIImageView!
    
    
    @IBOutlet weak var titleText: UILabel!
    
    
    @IBOutlet weak var messageCountText: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        userIconImage.layer.cornerRadius = userIconImage.bounds.height / 2
        userIconImage.clipsToBounds = true
    }
    
}
