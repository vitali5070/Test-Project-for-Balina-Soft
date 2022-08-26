//
//  MainViewController+extensions.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell().identifier, for: indexPath) as! MainTableViewCell
        let model = self.models[indexPath.section]
        guard let model = model.content?[indexPath.row] else { return UITableViewCell() }
        cell.configure(withModel: model, downloadManger: self.downloadManager)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let numberOfPages = self.models[section].totalPages else { return nil }
        if section <= numberOfPages {
            return "Page No.\(section + 1)"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = self.models[section].content?.count else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let objectsInSection = self.models[indexPath.section].content else { return }
        let lastObjectInsection = objectsInSection.count - 1
        if indexPath.row == lastObjectInsection && tableView.numberOfSections < self.models[indexPath.section].totalPages! {
            let url = "https://junior.balinasoft.com/api/v2/photo/type?page=" + "\(tableView.numberOfSections)"
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.fetchModelData(withURL: url)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.models.count
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let index = self.models[indexPath.section].content?[indexPath.row].id else { return }
        let picker = PhotoViewController()
        picker.index = Int(index)
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picker = picker as? PhotoViewController else { return }
        picker.dismiss(animated: true)
        guard let image = info[PhotoViewController.InfoKey.originalImage] as? UIImage else { return }
        guard let index = picker.index else { return }
        let postModel: PostModel = PostModel(typeId: String(index), name: self.getDeveloperName(), photo: image)
        self.uploadManager.uploadPhoto(withPostModelData: postModel)
    }
}

extension MainViewController {
    fileprivate func getDeveloperName() -> String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        let appNameArray = appName.components(separatedBy: ".")
        if appNameArray.count > 1 {
            return appNameArray[1]
        } else {
            return ""
        }
    }
}
