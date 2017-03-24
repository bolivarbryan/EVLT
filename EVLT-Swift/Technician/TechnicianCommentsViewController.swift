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
    
    let paragraphs = ["The comments taken by the commercial should not be modified by the technicians but they should be able to add new ones", "The comments taken by the commercial should not be modified by the technicians but they should be able to add new ones The comments taken by the commercial should not be modified by the technicians but they should be able to add new ones", "dddd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.project.comments != nil {
            //self.textView.text = project.comments!
        }
        let newButton = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    func new() {
        ELVTAlert.showFormWithFields(controller: self, message: NSLocalizedString("Add new Comment", comment: ""), fields: ["Comment"]) { (results) in
            print(results[0])
        }
        /*
        if let comment = self.textView.text {
            // api request
            APIRequests.saveComment(project: project, comment: comment, completion: { (result) in
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITableView Methods
extension TechnicianCommentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.attributedText =  makeAttributedString(subtitle: "• " + paragraphs[indexPath.row])
        //cell.textLabel?.font = UIFont(name: "Helvetica", size: 13.0)
        //cell.textLabel?.textColor = UIColor.black
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
        return paragraphs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: 40))
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let label = UILabel(frame: view.bounds)
        label.font =  UIFont(name: "Helvetica-Bold", size: 14.0)
        label.text = section == 0 ? "Administrative" : "Technician"
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
