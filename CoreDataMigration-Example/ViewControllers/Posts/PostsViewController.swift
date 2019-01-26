//
//  PostsViewController.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit
import CoreData

class PostsViewController: UITableViewController {

    var posts = [Post]()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Viewer" {
            if let postViewCcontroller = segue.destination as? PostViewerViewController, let tableViewCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: tableViewCell) {
                let post = posts[indexPath.row]
                let viewModel = postViewerViewModel(forPost: post)
                postViewCcontroller.configure(withViewModel: viewModel)
            }
        }
    }
    
    // MARK: - Load
    
    private func loadData() {
        let context = CoreDataManager.shared.mainContext
        let request = NSFetchRequest<Post>.init(entityName: "Post")
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "softDeleted == NO")
        
        request.sortDescriptors = [dateSort]
        request.predicate = predicate
        posts = try! context.fetch(request)
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let viewModel = cellViewModel(forPost: post)
        cell.configure(withViewModel: viewModel)
        
        return cell
    }
    
    // MARK: - ViewModels
    
    private func cellViewModel(forPost post: Post) -> PostTableViewCellViewModel {
        let backgroundColor = UIColor.colorWithHex(hexColor: post.hexColor!) ?? UIColor.white
        let formattedDate = dateFormatter.string(from: post.date!)
        let typedSections = post.sections as! Set<Section>
        let firstSection = typedSections.sorted { $0.index < $1.index }.first!
        let preview = firstSection.title!.count > 0 ? firstSection.title! : firstSection.body!
        
        return PostTableViewCellViewModel(preview: preview, date: formattedDate, backgroundColor: backgroundColor)
    }
    
    private func postViewerViewModel(forPost post: Post) -> PostViewerViewModel {
        let backgroundColor = UIColor.colorWithHex(hexColor: post.hexColor!) ?? UIColor.white
        let typedSections = post.sections as! Set<Section>
        
        let sections = typedSections.sorted { $0.index < $1.index }.map { PostViewerSectionViewModel(title: $0.title!, body: $0.body!) }
        
        return PostViewerViewModel(postID: post.postID!, sections: sections, backgroundColor: backgroundColor)
    }
}
