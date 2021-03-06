//
//  ImageCacheHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class ImageCacheHandler: NSObject {

    func imageNameFrom(_ url: String?) -> String?{
        
        if let url = url
        {
            let urlSeparated: Array<String> = url.components(separatedBy: "/")
            return urlSeparated.last;
        }
        
        return nil
    }
    
    func imageForUrl(_ url: String?, andReturn block:@escaping (_ image: UIImage?) -> Void) {
        
        let tmpFolderUrl: URL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        
        if let imageName = self.imageNameFrom(url)
        {
            let imageUrl: URL = tmpFolderUrl.appendingPathComponent(imageName)
            
            if let cacheImage = UIImage(contentsOfFile: imageUrl.path)
            {
                block(cacheImage); return
            }
                
            let sesion: URLSession = URLSession(configuration: URLSessionConfiguration.default)
            let set: CharacterSet = CharacterSet.urlQueryAllowed
            let imageNameEncoded: String = url!.addingPercentEncoding(withAllowedCharacters: set)!
            let imageServerUrl: URL? = URL(string: imageNameEncoded)
            
            if let imageServerUrl = imageServerUrl
            {
                let task: URLSessionDataTask = sesion.dataTask(with: imageServerUrl) { (data, urlResponse, error) in
                    
                    if error != nil
                    {
                        block(nil); return
                    }
                        
                    try! data!.write(to: imageUrl)
                    let imageToCache = UIImage(data: data!)
                    block(imageToCache)
                };
                
                task.resume();
            }
            else
            {
                block(nil)
            }
        }
        else
        {
            block(nil)
        }
    }
}
