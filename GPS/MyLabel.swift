//
//  MyLabel.swift
//  GPS
//
//  Created by Andre Unsal on 2/18/19.
//  Copyright © 2019 Andre Unsal. All rights reserved.
//

import UIKit

class MyLabel: UILabel
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initializeLabel()
    }
    
    func initializeLabel()
    {
        self.textAlignment = .center
        self.font = UIFont(name: "Helvetica", size: 18)
        //self.textColor = UIColor.black
        //self.text = "Testing."
    }
}
