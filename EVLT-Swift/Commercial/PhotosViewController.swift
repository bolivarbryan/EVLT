//
//  PhotosViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosViewController: UIViewController {
    var project:Project!
    var photoUrls:[Photo] = []
    var selectedPhoto: Photo? = nil
    var selectedImage: UIImage!
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 50.0, right: 10.0)
    var isTechincianParentController: Bool? = nil

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTechincianParentController == nil {
            let newButton = UIBarButtonItem(title: NSLocalizedString("Add...", comment: ""), style: .done, target: self, action: #selector(new))
            self.navigationItem.rightBarButtonItem = newButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        APIRequests.listPhotos(projectID: "\(self.project.chantier_id)") { (photos) in
            print(photos)
            self.photoUrls = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func new() {
        selectedPhoto = nil
       self.performSegue(withIdentifier: "AddPhoto", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "AddPhoto" {
            let vc = segue.destination as! AddPhotoViewController
            vc.project = self.project
            vc.imageCount = self.photoUrls.count
            vc.photo = self.selectedPhoto
        }else {
            
            if segue.identifier == "AddPhotoDetails" {
                let vc = segue.destination as! AddPhotoViewController
                vc.project = self.project
                vc.imageCount = self.photoUrls.count
                vc.photo = self.selectedPhoto
                vc.selectedImage = self.selectedImage
            }
        }
    }
}


extension PhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoIdentifier", for: indexPath) as! PhotoCell
        cell.image.image = UIImage()
        cell.backgroundColor = UIColor.lightGray
        
        EVLTStorageManager.sharedInstance.getImageFromURL(urlString: photoUrls[indexPath.row].url) { (image) in
            DispatchQueue.main.async {
                cell.image.sd_setImage(with: image, placeholderImage: UIImage())
                cell.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPhoto =  photoUrls[indexPath.row]
        self.selectedImage = (self.collectionView.cellForItem(at: indexPath) as! PhotoCell).image.image!

        self.performSegue(withIdentifier: "AddPhotoDetails", sender: self)
    }
}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
}
//MARK: Tableview Protocols
extension PhotosViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "PhotoIdentifier"
        //var cell = tableView.dequeueReusableCell(withIdentifier: "")  as CellClass
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier )
        cell.textLabel?.text = photoUrls[indexPath.row].comment

        EVLTStorageManager.sharedInstance.getImageFromURL(urlString: photoUrls[indexPath.row].url) { (image) in
            cell.imageView?.sd_setImage(with: image, completed: { (image, error, cache, URL) in
                cell.setNeedsLayout()
            })
        }
        
        return cell
    }
}

extension PhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //if isTechincianParentController == nil {
        self.selectedPhoto =  photoUrls[indexPath.row]
            self.performSegue(withIdentifier: "AddPhotoDetails", sender: self)
        //}
    }
}

