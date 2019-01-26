//
//  PostWriterViewController.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 13/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit
import CoreData

class PostWriterViewController: UITableViewController, PostSectionWriterTableViewCellDelegate {
    
    var contentSectionViewModels = [PostSectionWriterTableViewCellViewModel]()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 220.0
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNewSectionToTableView()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentSectionViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentSectionViewModel = contentSectionViewModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostSectionTableViewCell", for: indexPath) as! PostSectionWriterTableViewCell
        
        cell.configure(withViewModel: contentSectionViewModel)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - ButtonActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.backgroundContext
            context.performAndWait {
                let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as! Post
                post.postID = UUID().uuidString
                post.date = Date()
                post.hexColor = UIColor.randomPastelColor.hexString
                
                for (index, viewModel) in self.contentSectionViewModels.enumerated() {
                    guard viewModel.title.count > 0 || viewModel.body.count > 0 else {
                        continue
                    }
                    
                    let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: context) as! Section
                    section.title = viewModel.title
                    section.body = viewModel.body
                    section.index = Int16(index)
                    
                    section.post = post
                    post.addToSections(section)
                }
                
                if post.sections?.count ?? 0 > 0 {
                    try? context.save()
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addSectionButtonPressed(_ sender: Any) {
        view.endEditing(true)
        addNewSectionToTableView()
        scrollToLastSection()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Section
    
    func addNewSectionToTableView() {
        let viewModel =  PostSectionWriterTableViewCellViewModel(title: "", body: "")
        contentSectionViewModels.append(viewModel)
        
        tableView.reloadData()
    }
    
    func scrollToLastSection() {
        let lastIndex = (contentSectionViewModels.count - 1)
        let lastIndexPath = IndexPath(item: lastIndex, section: 0)
        
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    // MARK: - PostSectionWriterTableViewCellDelegate
    
    func didSetTitle(cell: PostSectionWriterTableViewCell, to title: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        var viewModel = contentSectionViewModels[indexPath.row]
        viewModel.title = title
        
        contentSectionViewModels[indexPath.row] = viewModel
    }
    
    func didSetBody(cell: PostSectionWriterTableViewCell, to body: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        var viewModel = contentSectionViewModels[indexPath.row]
        viewModel.body = body
        
        contentSectionViewModels[indexPath.row] = viewModel
    }
}
