//
//  EVLTStorageManager.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation
import Firebase

struct EVLTStorageManager {
    let kStorageServerURl = "https://firebasestorage.googleapis.com"
    //MARK: Shared Instance

    static let sharedInstance : EVLTStorageManager = {
        let instance = EVLTStorageManager()
        return instance
    }()
    
    init() {
        FIRApp.configure()
    }
    
    func setup()  {
        
    }
    
    func saveImageReference(name:String, image: UIImage, completion: @escaping (_ url: String) -> Void){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://evlt-62b3b.appspot.com/")
        
        //transforming image in data
        let data = UIImagePNGRepresentation(image) as Data?

        //transforming data in image
        //let imagePt = UIImage(data: (caminhodaImagem as! NSData) as Data)
        
        let imageReference = storageRef.child("images/\(name)")
        
        // Upload the file to the path "images/name"
        let _ = imageReference.put(data!, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
                DispatchQueue.main.async {
                    completion(downloadURL()!.absoluteString)
                }
                
            }
        }
    }
    
    func getImageFromURL(urlString: String, completion: @escaping (_ image: URL) -> Void ) {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://evlt-62b3b.appspot.com/")
        let imageReference = storageRef.child("images/\(urlString)")

        // Fetch the download URL
        imageReference.downloadURL { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
            } else {
                completion(URL!)
            }
        }
        
       
    }
}
