//
//  AddPhotoViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
import DGActivityIndicatorView
import SDWebImage

class AddPhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var project:Project!
    var imageCount:Int!
    //image picker
    var imagePicker: UIImagePickerController!
    var photo: Photo?
    
    @IBOutlet weak var textView: UITextView!
    private let kErrorMessage = "Please select an image before"
    private let kSuccessSaving = "Image Saved in"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        if let p = self.photo {
            //self.showCommentBox.setTitle(p.comment, for: .normal)
            self.textView.text = p.comment
            EVLTStorageManager.sharedInstance.getImageFromURL(urlString: p.url) { (image) in
                self.imageView?.sd_setImage(with: image, completed: { (image, error, cache, URL) in
                })
            }
        }
    }
    
    func new() {
        //formtting a valid name
        if self.showCommentBox.title(for: .normal)! == "Comment" {
            ELVTAlert.showFormWithFields(controller: self, message: NSLocalizedString("Insert a Comment", comment: ""), fields: ["Comment"]) { (results) in
                self.showCommentBox.setTitle(results[0], for: .normal)
                self.save()
            }
        } else {
            self.save()
        }
       
    }
    
    func save() {
        //TODO: reduce image quality for saving memory storage
        if let image = self.imageView.image {
            let name = "\(project.chantier_id)-\(EVLTDateFormatter.stringFromDate(date: Date()))-\(imageCount!).png"
            
            //Adding Spinner
            var activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
            let aiView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            
            activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
            activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            activityIndicatorView?.startAnimating()
            aiView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            aiView.addSubview(activityIndicatorView!)
            UIApplication.shared.keyWindow?.addSubview(aiView)
            aiView.isHidden = false
            
            
            EVLTStorageManager.sharedInstance.saveImageReference(name: name, image:image) { (completion) in
                print(completion)
                aiView.isHidden = true
                //Send url to server here
                var status = "CREATION"
                var photoObject = Photo(url: name, comment: self.showCommentBox.title(for: .normal)!)
                
                APIRequests.projectPhoto(projectID: "\(self.project.chantier_id)", status: status, photo: photoObject, comment: self.showCommentBox.title(for: .normal)!, completion: { (done) in
                    DispatchQueue.main.async {
                        self.goBack()
                    }
                    
                })
            }
        }else{
            ELVTAlert.showMessage(controller: self, message: kErrorMessage, completion: { (done) in })
            
        }
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var showCommentBox: UIButton!
    @IBAction func displayCommentBox(_ sender: Any) {
        ELVTAlert.showFormWithFields(controller: self, message: NSLocalizedString("Insert a Comment", comment: ""), fields: ["Comment"]) { (results) in
            self.showCommentBox.setTitle(results[0], for: .normal)
        }
    }
    
}


extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
         dismiss(animated: true, completion: nil)
    }
    
}
