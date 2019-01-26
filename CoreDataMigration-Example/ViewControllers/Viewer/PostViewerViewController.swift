//
//  PostViewerViewController.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 13/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit
import CoreData

struct PostViewerViewModel {
    
    let postID: String
    let sections: [PostViewerSectionViewModel]
    let backgroundColor: UIColor
}

struct PostViewerSectionViewModel {
    
    let title: String
    let body: String
}

class PostViewerViewController: UITableViewController {

    private var viewModel: PostViewerViewModel!
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.backgroundColor = viewModel.backgroundColor
    }
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: PostViewerViewModel) {
        self.viewModel = viewModel
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentSectionViewModel = viewModel.sections[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostSectionViewerTableViewCell", for: indexPath) as! PostSectionViewerTableViewCell
        
        cell.configure(withViewModel: contentSectionViewModel)
        
        return cell
    }
    
    // MARK: - ButtonActions
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.backgroundContext
            context.performAndWait {
                let request = NSFetchRequest<Post>.init(entityName: "Post")
                request.predicate = NSPredicate(format: "postID == '\(self.viewModel.postID)'")

                let post = try! context.fetch(request).first!
                post.softDeleted = true

                try? context.save()

                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
