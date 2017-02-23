//
//  EVLTPicker.swift
//  EVLT-Swift
//
//  Created by Bryan on 22/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation
protocol EvltPickerDelegate {
    func pickerDismissed(index: Int?)
}
class EVLTPicker: UIPickerView {
    var evltPickerDelegate: EvltPickerDelegate!
    var components: Array<(name:String, values:[String])>!
    var message: String = ""
    private static let kPickerHeight: CGFloat = 180
    let doneButton = UIButton()
    var backgroundView:UIView? = nil
    var titleLabel: UILabel!
    let kColorButton = UIColor.color(r: 73, g: 129, b: 199)
    static let sharedInstance : EVLTPicker = {
        let instance = EVLTPicker(components:[])
        return instance
    }()
    
    init(components: Array<(name:String, values:[String])>) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.components = components
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPicker(inController controller: UIViewController, withMessage message:String, values: [String]) {
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.backgroundColor = kColorButton
        self.doneButton.setTitleColor(UIColor.white, for: .normal)
        self.backgroundView = UIView()
        self.doneButton.addTarget(self, action: #selector(hidePicker), for: .touchUpInside)
        self.dataSource = self
        self.delegate = self
        self.showsSelectionIndicator = true
        self.components = [(name: message, values: values)]
        self.reloadAllComponents()
        self.selectRow(0, inComponent: 0, animated: true)
        self.message = message
        self.showPicker(controller: controller)
    }
    
    private func showPicker(controller: UIViewController) {
        //bg image
        self.backgroundView?.frame = controller.view.bounds
        controller.view.addSubview(self.backgroundView!)
        
        //create animation
        self.backgroundView?.backgroundColor = UIColor(white: 0.0, alpha: 0)
        self.frame = CGRect(x: 0, y: controller.view.frame.size.height + 20, width: controller.view.frame.size.width, height: EVLTPicker.kPickerHeight)
        self.doneButton.frame = CGRect(x: 0, y: controller.view.frame.size.height + EVLTPicker.kPickerHeight + 50.0  + 20 , width: controller.view.frame.width, height: 50.0)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: controller.view.frame.size.height, width: self.bounds.width, height: 22))
        titleLabel.text = message
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica-Neue", size: 12)
        titleLabel.textColor = UIColor.lightGray
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView?.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
            self.frame = CGRect(x: 0, y: controller.view.frame.size.height - EVLTPicker.kPickerHeight - 50.0 , width: controller.view.frame.size.width, height: EVLTPicker.kPickerHeight)
            self.doneButton.frame = CGRect(x: 0, y: controller.view.frame.size.height - 50.0 , width: controller.view.frame.width, height: 50.0)
            self.titleLabel.frame = CGRect(x: 0, y: self.frame.origin.y-20, width: self.bounds.width, height: 20)
        }

        self.backgroundColor = UIColor.white
        controller.view.addSubview(self)
        controller.view.addSubview(doneButton)
        controller.view.addSubview(titleLabel)

    }
    
    @objc private func hidePicker() {
        self.backgroundView?.removeFromSuperview()
        self.doneButton.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.removeFromSuperview()
        
        //CALL KVC
        
        //TODO: Add Support to multiple components
        self.evltPickerDelegate.pickerDismissed(index: self.selectedRow(inComponent: 0) )
    }
    
}

extension EVLTPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components[component].values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[component].values[row]
    }
}

extension EVLTPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.doneButton.setTitle("Select \(components[component].values[row])", for: .normal)
    }
    
}

//TODO MOVE THIS

extension UIColor {
    static func color(r: Double, g: Double, b: Double) -> UIColor {
        let red = CGFloat(r / 255.0)
        let green = CGFloat(g / 255.0)
        let blue = CGFloat(b / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
