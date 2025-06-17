//
//  TableViewCell.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

protocol TableViewCellDelegate:  AnyObject {
    func shortlist(at index : IndexPath)
}

class TableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor  = UIColor.white
    }
    
    @IBOutlet weak var Name : UILabel!
    @IBOutlet weak var Gpa : UILabel!
    @IBOutlet weak var University : UILabel!
    @IBOutlet weak var Skills : UILabel!
    
    @IBOutlet weak var NameValue : UILabel!
    @IBOutlet weak var GpaValue : UILabel!
    @IBOutlet weak var UniversityValue : UILabel!
    @IBOutlet weak var SkillsValue : UILabel!
    
    @IBOutlet weak var shortlistButton : UIButton!
    //    shortlistButton.titleLabel?.textAlignment = .center
    //    @IBOutlet weak var crossoffButton : UIButton!
    
    var delegate: TableViewCellDelegate?
    var data: Student?
    var index : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func shortlistTapped(_ sender: UIButton)  {
        
        print("Shortlist tapped")
        //        self.backgroundColor  = UIColor.gray
        if let data = self.data {
            delegate?.shortlist(at : self.index!)
        }
        
    }
    
    func configure (_ data : Student ) {
        self.data = data
        textConvertor("Name : ", Name)
        Name.numberOfLines = 0
        Name.lineBreakMode = .byWordWrapping
        NameValue.text! = data.name!
        NameValue.numberOfLines = 0
        NameValue.lineBreakMode = .byWordWrapping
        
        textConvertor("Gpa : ", Gpa)
        Gpa.numberOfLines = 0
        Gpa.lineBreakMode = .byWordWrapping
        GpaValue.text! = String(data.gpa!)
        GpaValue.numberOfLines = 0
        GpaValue.lineBreakMode = .byWordWrapping
        
        
        textConvertor("University : ", University)
        University.numberOfLines = 0
        University.lineBreakMode = .byWordWrapping
        UniversityValue.text! = data.university!
        UniversityValue.numberOfLines = 0
        UniversityValue.lineBreakMode = .byWordWrapping
        
        textConvertor("Skills : ", Skills)
        Skills.numberOfLines = 0
        Skills.lineBreakMode = .byWordWrapping
        SkillsValue.text! = data.skills!
        SkillsValue.numberOfLines = 0
        SkillsValue.lineBreakMode = .byWordWrapping
        
        if data.isShortlisted  == true{
            shortlistButton.tintColor  = UIColor.systemGray
            shortlistButton.setTitle("Shortlisted", for: .normal)
        } else {
            shortlistButton.setTitle("Shortlist", for: .normal)
            shortlistButton.tintColor = UIColor.systemBlue
        }
        
    }
    
    func textConvertor(_ lhs: String ,_ lbl : UILabel) ->  Void {
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
        ]
        
        let boldText = NSAttributedString(string: lhs, attributes: boldAttribute)
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        lbl.attributedText = newString
        
        //        let regularAttribute = [
        //           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 17.0)!
        //        ]
        //        let regularText = NSAttributedString(string: rhs, attributes: regularAttribute)
        //        lblValue.text = rhs
    }
}
