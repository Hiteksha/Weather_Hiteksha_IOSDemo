//
//  ForeCastCell.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 23/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit

class ForeCastCell: UICollectionViewCell {

    //Show the Humidity
    @IBOutlet var lblHumidity: UILabel!
    
    //Show the Temrature
    @IBOutlet var lblTemprature: UILabel!
    
    //Show the Date
    @IBOutlet var lblDate: UILabel!
    
    //Show the Wind Information
    @IBOutlet var windInformation: UILabel!
    
    //Show the Chance of Rain
    @IBOutlet var rainChances: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
