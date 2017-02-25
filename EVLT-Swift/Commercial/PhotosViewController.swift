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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newButton = UIBarButtonItem(title: NSLocalizedString("Add...", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        APIRequests.listPhotos(projectID: "\(self.project.chantier_id)") { (photos) in
            print(photos)
            self.photoUrls = photos
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
            }
        }
    }
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
        self.selectedPhoto =  photoUrls[indexPath.row]
        self.performSegue(withIdentifier: "AddPhotoDetails", sender: self)
    }
}
