//
//  PickerView.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 31/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import UIKit

protocol PickerViewDelegate {
    func doneButtonTapped()
    func pickerViewSelectionChangedWithIndex(index: Int)
}

class PickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    var delegate: PickerViewDelegate?
    var numberOfItems: Int!
    
    func setupWithDelegate(aDelegate: PickerViewDelegate, itemsNumber: Int) {
        delegate = aDelegate
        picker.delegate = self
        numberOfItems = itemsNumber
    }
    
    @IBAction func doneTapped(sender: UIButton) {
        delegate?.doneButtonTapped()
    }
    
    // MARK: picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfItems
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerViewSelectionChangedWithIndex(row)
    }

}
