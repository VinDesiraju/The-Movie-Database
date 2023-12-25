//
//  MovieCell.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 3/24/23.
//

import UIKit

class MovieCell: UITableViewCell {

    // Creating outlets for the movie image and title in the tableviewcell.
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet var votecount: UILabel!
    @IBOutlet var fav: UISwitch!
    
    var switchValueChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib() // Initialization code
        
        //fav.tag = self.tag
        fav.addTarget(self, action: #selector(favToggled(_:)), for: .valueChanged)
    }

    @objc private func favToggled(_ sender: UISwitch) {
        if sender.isOn {
                    print("Switch turned on")
                    switchValueChanged?(fav.isOn)
                } else {
                    switchValueChanged?(false)
                    print("Switch turned off")
                    // Perform action here when switch is turned off from on
                }
        
        }
    
    func turnSwitchOn(val: Bool) {
        // Set the isOn property of the switch to true
       // DispatchQueue.main.async {
        if val {
            self.fav.isOn = true
        }
        else {
            self.fav.isOn = false
        }
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) // Configure the view for the selected state
    }
}

