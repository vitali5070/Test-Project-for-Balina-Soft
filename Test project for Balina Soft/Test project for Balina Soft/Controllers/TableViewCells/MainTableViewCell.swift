//
//  MainTableViewCell.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    public let identifier: String = "MainCell"
    
    private let nameTitleLabel: UILabel = UILabel()
    private let idTitleLabel: UILabel = UILabel()
    private let photoImageView: UIImageView = UIImageView()
    
    public func configure(withModel model: Content, downloadManger: DownloadManager) {

        self.nameTitleLabel.text = model.name
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(nameTitleLabel)
        
        NSLayoutConstraint.activate([
            nameTitleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            nameTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.idTitleLabel.text = String(model.id!)
        idTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(idTitleLabel)
        
        NSLayoutConstraint.activate([
            idTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            idTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
                
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit

        self.contentView.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor)
        ])
        
        if let url = model.image {
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                downloadManger.downloadImagefromURL(url) { [weak self] result in
                    switch result{
                    case .failure(let error):
                        print(String(describing: error))
                    case .success(let data):
                        DispatchQueue.main.async {
                            guard let image = UIImage(data: data) else { return }
                            self?.photoImageView.image = image;
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameTitleLabel.text = nil
        self.idTitleLabel.text = nil
        self.photoImageView.image = nil
    }
}
