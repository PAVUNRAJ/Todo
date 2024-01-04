//
//  CategoryCell.swift
//  TodoList
//
//  Created by PavunRaj on 03/01/24.
//

import UIKit
import SwipeCellKit

class CategoryCell: SwipeTableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
