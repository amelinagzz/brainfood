//
//  Results.swift
//  BrainTeaser
//
//  Created by Adriana Gonzalez on 4/22/16.
//  Copyright © 2016 Adriana Gonzalez. All rights reserved.
//

import UIKit

protocol ResultsDelegate: class {
    func restart()
}

class Results: UIView {
    
    var correct: Int!
    var error: Int!

    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    weak var delegate:ResultsDelegate?

    override func awakeFromNib() {
        self.frame = bounds
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.frame = bounds

    }
    
    func setupView(){
        
        lblCorrect.text = "Correct: \(correct)"
        lblError.text = "Errors: \(error)"
        lblTotal.text = "Total cards: \(correct + error)"
    }

    @IBAction func restartBtnPressed(sender: AnyObject) {
        delegate?.restart()
    }
}
