//
//  PostSectionViewerTableViewCell.swift
//  CoreDataMigration-Example
//
//  Created by Boles, William (Developer) on 17/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class PostSectionViewerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        bodyLabel.text = nil
    }
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: PostViewerSectionViewModel) {
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
    }
}
