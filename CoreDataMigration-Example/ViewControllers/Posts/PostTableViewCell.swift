//
//  PostTableViewCell.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

struct PostTableViewCellViewModel {
    
    let preview: String
    let date: String
    let backgroundColor: UIColor
}

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Configure
    
    func configure(withViewModel viewModel: PostTableViewCellViewModel) {
        contentLabel.text = viewModel.preview
        dateLabel.text = viewModel.date
        contentView.backgroundColor = viewModel.backgroundColor
    }
    
}
