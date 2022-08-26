//
//  UploadManager.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

class UploadManager: NSObject {
    
    func uploadPhoto(withPostModelData postModelData: PostModel) {
        let urlPostString: String = "https://junior.balinasoft.com/api/v2/photo"
        guard let url: URL = URL(string: urlPostString) else { return }
        var request = URLRequest(url: url)
        let boundary: String = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let name: String = postModelData.name
        let typeId: String = postModelData.typeId
        
        let postParam = [
            "name": "\(name)",
            "typeId": "\(typeId)"
        ]
        
        let photo = PhotoModel(withImage: postModelData.photo, forKey: "photo")
        guard let photo = photo else { return }
        request.httpBody = createDataBody(withParameters: postParam, photo: photo, boundary: boundary)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let response = try? JSONSerialization.jsonObject(with: data)
            print("response = \(String(describing: response))")
        }
        dataTask.resume()
    }
    
    func createDataBody(withParameters parameters: [String: String]?, photo: PhotoModel, boundary: String) -> Data {
        let lineBreak: String = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.appendString("--\(boundary + lineBreak)")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.appendString("\(value + lineBreak)")
            }
        }
        
        body.appendString("--\(boundary + lineBreak)")
        body.appendString("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
        body.appendString("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
        body.append(photo.data)
        body.appendString("\(lineBreak)")
        
        body.appendString("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
