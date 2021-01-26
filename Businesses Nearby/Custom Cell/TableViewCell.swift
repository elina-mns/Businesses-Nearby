//
//  TableViewCell.swift
//  Businesses Nearby
//
//  Created by Elina Mansurova on 2021-01-26.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var imageOfBusiness: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static let identifier = "TableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell",
                     bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
