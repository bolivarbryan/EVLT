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
    var paragraphs:[(name: String, values: [(id: String, value:String)])] = []
    //JSON: ["comments": ["technician":["comment 1", "comment 2", "comment 3"], "administrative": "comment 1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .done, target: self, action: #selector(new))
        
        self.navigationItem.rightBarButtonItem = newButton
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //getting comments from api
        APIRequests.getComments(project: self.project) { (results) in
            print(results)
            //filtering comments
            var commercialComments = [(id: String, value:String)]()
            var adminComments = [(id: String, value:String)]()
            var savComments = [(id: String, value:String)]()
            var techComments = [(id: String, value:String)]()
            
            for comment in (results as! Dictionary<String, Any>)["results"] as! Array<Dictionary<String, Any >> {
                switch comment["auteur"] as! String {
                case "Commercial":
                    commercialComments.append( (id:comment["id"] as! String, value: comment["commentaire"] as! String))
                case "Administrative":
                    adminComments.append( (id:comment["id"] as! String, value: comment["commentaire"] as! String))
                case "SAV":
                    savComments.append( (id:comment["id"] as! String, value: comment["commentaire"] as! String))
                default:
                    techComments.append( (id:comment["id"] as! String, value: comment["commentaire"] as! String))
                }
            }
            
            self.paragraphs.append((name: "Commercial", values: commercialComments))
            self.paragraphs.append((name: "Administrative", values: adminComments))
            self.paragraphs.append((name: "SAV", values: savComments))
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
            cell.textLabel?.attributedText =  makeAttributedString(subtitle: "• " + paragraphs[indexPath.section].values[indexPath.row].value)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            ELVTAlert.showConfirmationMessage(controller: self, message: NSLocalizedString("Are you you sure you want to delete this comment?", comment: ""), completion: { (done) in
                if done == true {
                    APIRequests.deleteComment(id: self.paragraphs[indexPath.section].values[indexPath.row].id, completion: { (results) in
                        DispatchQueue.main.async {
                            self.paragraphs[indexPath.section].values.remove(at: indexPath.row)
                            self.tableView.reloadData()
                        }
                    })
                }
            })
        }
        
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            ELVTAlert.showFormEditField(controller: self, message: NSLocalizedString("Edit Comment", comment: ""), field: "Comment", currentValue: self.paragraphs[indexPath.section].values[indexPath.row].value, completion: { (result) in
                self.paragraphs[indexPath.section].values[indexPath.row].value = result[0]

                APIRequests.editComment(comment: result[0], commentID: self.paragraphs[indexPath.section].values[indexPath.row].id, completion: { (results) in
                    //updating value
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
                
            })
        }
        
        edit.backgroundColor = .orange
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var canEdit = true
        
        if paragraphs[indexPath.section].values.count > 0 {
            //validate if is a technician, commercial o admin
            if self.authorString != self.paragraphs[indexPath.section].name {
                canEdit = false
            }
        }else{
            canEdit = false
        }
        
        return canEdit
    }
}

extension TechnicianCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
