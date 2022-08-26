//
//  MainViewController.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

class MainViewController: UIViewController {
    
    public let urlGetString: String = "https://junior.balinasoft.com/api/v2/photo/type"
    public var models: [GetModel] = []
    public let downloadManager: DownloadManager = DownloadManager()
    public let uploadManager: UploadManager = UploadManager()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell().identifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    fileprivate let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchModelData(withURL: urlGetString)
        self.prepareTableView()
        prepareActivityIndicator()
    }
    
    fileprivate func prepareActivityIndicator() {
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        self.activityIndicator.startAnimating()
    }
    
    fileprivate func prepareTableView() {
        self.view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
    }
    
    public func fetchModelData(withURL url: String) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let url: URL? = URL(string: url)
            guard let url = url else { return }
            self.downloadManager.getDataFromURL(url) { [weak self] (data, response, error) in
                do {
                    guard let data = data else { return }
                    let getModel = try JSONDecoder().decode(GetModel.self, from: data)
                    self?.models.append(getModel)
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.tableView.reloadData()
                    }
                    return
                } catch {
                    print(String(describing: error))
                }
            }
            
        }
    }
    
    
    
}
