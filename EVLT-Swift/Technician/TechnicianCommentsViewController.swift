//
//  TechnicianCommentsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class TechnicianCommentsViewController: UIViewController {
    var project: Project!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var authorString: String! = nil
    var paragraphs:[(name: String, values: [String])] = []
    //JSON: ["comments": ["technician":["comment 1", "comment 2", "comment 3"], "administrative": "comment 1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.project.comments != nil {
            //self.textView.text = project.comments!
        }
        let newButton = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
  
        //paragraphs.append(comment)
        
        //getting comments from api
        APIRequests.getComments(project: self.project) { (results) in
            print(results)
            //filtering comments
            var commercialComments = [String]()
            var adminComments = [String]()
            var techComments = [String]()
            
            for comment in (results as! Dictionary<String, Any>)["results"] as! Array<Dictionary<String, Any >> {
                switch comment["auteur"] as! String {
                case "Commercial":
                    commercialComments.append(comment["commentaire"] as! String)
                case "Administrative":
                    adminComments.append(comment["commentaire"] as! String)
                default:
                    techComments.append(comment["commentaire"] as! String)
                }
            }
            self.paragraphs.append((name: "Commercial", values: commercialComments))
            self.paragraphs.append((name: "Administrative", values: adminComments))
            self.paragraphs.append((name: "Technician", values: techComments))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    func new() {
        ELVTAlert.showFormWithFields(controller: self, message: NSLocalizedString("Add new Comment", comment: ""), fields: ["Comment"]) { (results) in
            print(results[0])
            APIRequests.saveComment(project: self.project, comment: results[0],author: self.authorString , completion: { (result) in
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: UITableView Methods
extension TechnicianCommentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.paragraphs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        if paragraphs[indexPath.section].values.count > 0 {
            cell.textLabel?.attributedText =  makeAttributedString(subtitle: "• " + paragraphs[indexPath.section].values[indexPath.row])
        } else {
            cell.textLabel?.attributedText = makeAttributedString(subtitle: "• " + NSLocalizedString("No Comments.", comment: ""))
        }
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paragraphs[section].values.count == 0 {
            return 1
        } else {
            return paragraphs[section].values.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: 40))
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let label = UILabel(frame: view.bounds)
        label.font =  UIFont(name: "Helvetica-Bold", size: 14.0)
        label.text =  paragraphs[section].name
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
    func makeAttributedString(subtitle: String) -> NSAttributedString {
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .footnote)]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        return subtitleString
    }
    
}

extension TechnicianCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
