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
    var selectedImage: UIImage!
    var project:Project!
    var imageCount:Int!
    //image picker
    var imagePicker: UIImagePickerController!
    var photo: Photo?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textView: UITextView!
    private let kErrorMessage = "Please select an image before"
    private let kSuccessSaving = "Image Saved in"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton

        if let p = self.photo {
            self.textView.text = p.comment
            self.imageView.image = selectedImage
            self.scrollView.contentSize = self.imageView.frame.size;
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let p = self.photo {
                self.textView.text = p.comment
//                EVLTStorageManager.sharedInstance.getImageFromURL(urlString: p.url) { (image) in
//                    self.imageView?.sd_setImage(with: image, completed: { (image, error, cache, URL) in
//                    })
//                }
                
                self.scrollView.minimumZoomScale = 1.0;
                self.scrollView.maximumZoomScale = 6.0;
                self.scrollView.delegate = self;
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
            
            
            EVLTStorageManager.sharedInstance.saveImageReference(name: name, image:image.resized(withPercentage: 0.5)!) { (completion) in
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
        ELVTAlert.showCameraPickerOptions(controller: self, message: "Select a source") { (option) in
            if option == 1 {
                self.imagePicker = UIImagePickerController()
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }else{
                self.imagePicker = UIImagePickerController()
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
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
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
         dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension AddPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
