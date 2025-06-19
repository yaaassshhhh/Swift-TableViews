//
//  TableViewCell.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

protocol TableViewCellDelegate:  AnyObject {
    func shortlistStudent(at index : IndexPath)
}

class StudentTableViewCell: UITableViewCell {
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
    
    private weak var delegate: TableViewCellDelegate?
    private  var data: Student?
    private var index : IndexPath?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func shortlistTapped(_ sender: UIButton)  {
        print("Shortlist tapped")
        delegate?.shortlistStudent(at : self.index!)        
    }
    
    
    func configure (_ data : Student , delegate : TableViewCellDelegate, indexPath : IndexPath ) {
        self.index = indexPath
        self.delegate = delegate
        self.data = data
        
        configureLabelStyle(Name, NameValue)
        configureLabelStyle(Gpa, GpaValue)
        configureLabelStyle(University, UniversityValue)
        configureLabelStyle(Skills, SkillsValue)
        
        configureButtonStyle()
        
    }
    
    
    private func configureButtonStyle() {
        if data?.isShortlisted  == true{
            shortlistButton.tintColor  = UIColor.systemGray
            shortlistButton.setTitle("Shortlisted", for: .normal)
        } else {
            shortlistButton.setTitle("Shortlist", for: .normal)
            shortlistButton.tintColor = UIColor.systemBlue
        }
    }
    
    
    private func configureLabelStyle(_ labelKey : UILabel , _ labelValue : UILabel) {
        
        guard let text : String = labelKey.text else { return }
        textConvertor(text, labelKey)
        labelKey.numberOfLines = 0
        labelKey.lineBreakMode = .byWordWrapping
        
        switch text {
        case "Name: " :
            labelValue.text = data?.name!
            break
        case "Gpa: " :
            labelValue.text = String(format : "%.2f",data?.gpa ?? 0.0)
        case "University: " :
            labelValue.text = data?.university!
        case "Skills: " :
            labelValue.text = data?.skills!
        default :
            break
        }
        
        labelValue.numberOfLines = 0
        labelValue.lineBreakMode = .byWordWrapping
    }
    
    
    private func textConvertor(_ lhs: String ,_ lbl : UILabel) ->  Void {
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
        ]
        
        let boldText = NSAttributedString(string: lhs, attributes: boldAttribute)
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        lbl.attributedText = newString
    }
}
