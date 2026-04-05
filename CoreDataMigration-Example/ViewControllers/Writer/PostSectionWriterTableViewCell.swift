//
//  PostSectionTableViewCell.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 15/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

struct PostSectionWriterTableViewCellViewModel {
    
    var title: String
    var body: String
}

protocol PostSectionWriterTableViewCellDelegate: AnyObject {
    
    func didSetTitle(cell: PostSectionWriterTableViewCell, to title: String)
    func didSetBody(cell: PostSectionWriterTableViewCell, to body: String)
}

class PostSectionWriterTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    weak var delegate: PostSectionWriterTableViewCellDelegate?
    
    // MARK: - Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextField.delegate = self
        bodyTextView.delegate = self
    }
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: PostSectionWriterTableViewCellViewModel) {
        titleTextField.text = viewModel.title
        bodyTextView.text = viewModel.body
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField)  {
        delegate?.didSetTitle(cell: self, to: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didSetBody(cell: self, to: textView.text ?? "")
    }
}
