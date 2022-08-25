//
//  DownloadManager.swift
//  Test project for Balina Soft
//
//  Created by Vitali Nabarouski on 24.08.22.
//

import UIKit

class DownloadManager: NSObject {
    
    var dataComplition: ((Data) -> Void)!
    var imageDataCache = NSCache<NSString, NSData>()
    
    public func getDataFromURL(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func downloadImagefromURL (_ url: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        
        if let cashedImage = imageDataCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                completion(.success(cashedImage as Data))
            }
        } else {
            guard let urlU = URL(string: url) else { return }
            getDataFromURL(urlU) { [weak self] data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, error == nil else { return }
                self?.imageDataCache.setObject(data as NSData, forKey: url as NSString)
                DispatchQueue.main.async() {
                    completion(.success(data))
                }
            }
        }
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data: Data = try Data(contentsOf: location)
            DispatchQueue.main.async(execute: { [weak self] in
                self?.dataComplition(data)
            })
        } catch {
            print(String(describing: error))
        }
    }
}
