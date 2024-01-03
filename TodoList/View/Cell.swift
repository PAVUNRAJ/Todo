//
//  Cell.swift
//  TodoList
//
//  Created by PavunRaj on 02/01/24.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
