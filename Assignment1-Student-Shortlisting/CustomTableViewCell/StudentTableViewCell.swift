//
//  TableViewCell.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func shortlistStudent(_ shouldPopup : Bool, for studentName : String)
    func presentShareProfileActivity(for url : URL, activityController : UIActivityViewController)
}

class StudentTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor  = UIColor.white
    }
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Gpa: UILabel!
    @IBOutlet weak var University: UILabel!
    @IBOutlet weak var Skills: UILabel!
    
    @IBOutlet weak var NameValue: UILabel!
    @IBOutlet weak var GpaValue: UILabel!
    @IBOutlet weak var UniversityValue: UILabel!
    @IBOutlet weak var SkillsValue: UILabel!
    
    @IBOutlet weak var sharePopUpButton: UIButton!
    @IBOutlet weak var shortlistButton: UIButton!
    @IBOutlet weak var universityHeigh: NSLayoutConstraint!
    @IBOutlet weak var nameValyeHeight: NSLayoutConstraint!
    
    
    private weak var delegate: TableViewCellDelegate?
    
    private var index: IndexPath?
    private var cellVM: StudentCellViewModel?
    
    @IBAction func shortlistTapped( _ sender: UIButton ){
        print("Shortlist tapped")
        self.cellVM?.isShortlisted.toggle()
        delegate?.shortlistStudent((self.cellVM?.isShortlisted ?? false), for: (self.cellVM?.student.name ?? ""))
        configureShortlistButtonStyle()
    }
    
    
    func configure (_ data : StudentCellViewModel, delegate: TableViewCellDelegate?) {
        
        self.cellVM = data
        self.delegate = delegate
        
        configureLabelStyle(Name, NameValue)
        configureLabelStyle(Gpa, GpaValue)
        configureLabelStyle(University, UniversityValue)
        configureLabelStyle(Skills, SkillsValue)
        
        configureShortlistButtonStyle()
        setSharePopUpButton()
        configureLabelValueHeight()
    }
    
    private func configureLabelValueHeight(){
        nameValyeHeight?.isActive = false
        nameValyeHeight?.constant = NameValue.systemLayoutSizeFitting(CGSize(
            width: NameValue.frame.width, height: UIView.layoutFittingExpandedSize.height)).height
        nameValyeHeight?.isActive = true
        universityHeigh?.isActive = false
        universityHeigh?.constant = UniversityValue.systemLayoutSizeFitting(CGSize(width:  UniversityValue.frame.width, height:  UIView.layoutFittingExpandedSize.height)).height
        universityHeigh?.isActive = true
        self.layoutIfNeeded()
    }
    
    func setSharePopUpButton(){
        configureSharePopUpButton()
        let githubImage = UIImage(named: "github")
        let profileImage = UIImage(named: "contact")
        guard let url = self.cellVM?.genURL else { return }
        let shareProfileSelected = {(action : UIAction) in
            print("Profile Share Selected")
            let message  = ["Github Profile :\(url)" , "Check out this profile : \(self.cellVM?.name ?? "")"]
            print(message)
            let ac = UIActivityViewController(activityItems : message, applicationActivities: nil)
            
            self.delegate?.presentShareProfileActivity(for: url , activityController: ac)
        }
        let viewGithubSelected = {(action : UIAction) in
            UIApplication.shared.open(url ){ accepted in
                print(accepted ? "Success" : "Failure")
            }
        }
        
        sharePopUpButton.menu = UIMenu(
            children: [
                UIAction(title: "View Github", image: githubImage, handler: viewGithubSelected ),
                UIAction(title: "Share Profile", image: profileImage, handler: shareProfileSelected)
            ]
        )
    }
    
    private func configureSharePopUpButton(){
        sharePopUpButton.isHidden = false
        sharePopUpButton.isEnabled = true
        sharePopUpButton.setTitle("More", for: .normal)
        sharePopUpButton.setTitleColor(.systemBlue, for: .normal)
        sharePopUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        sharePopUpButton.showsMenuAsPrimaryAction = true
        sharePopUpButton.changesSelectionAsPrimaryAction = false
    }
    
    private func configureShortlistButtonStyle(){
        if cellVM?.isShortlisted == true{
            shortlistButton.tintColor = UIColor.systemGray
            print("\n \n Reaching here \n \n")
            shortlistButton.setTitle( "Shortlisted", for: .normal )
        } else {
            shortlistButton.setTitle( "Shortlist", for: .normal )
            shortlistButton.tintColor = UIColor.systemBlue
        }
    }
    
    
    private func configureLabelStyle(_ labelKey : UILabel , _ labelValue : UILabel) {
        
        guard let text : String = labelKey.text else { return }
        textConvertor(text, labelKey)
        labelKey.numberOfLines = 0
        labelKey.lineBreakMode = .byCharWrapping
        labelValue.numberOfLines = 0
        
        switch text {
        case "Name: " :
            labelValue.text = cellVM?.name
            labelValue.lineBreakMode = .byCharWrapping
            break
        case "Gpa: " :
            labelValue.text = String(format : "%.2f",cellVM?.gpa ?? 0.0)
            labelValue.lineBreakMode = .byCharWrapping
        case "University: " :
            labelValue.text = cellVM?.university
            labelValue.lineBreakMode = .byWordWrapping
        case "Skills: " :
            labelValue.text = cellVM?.skills
            labelValue.lineBreakMode = .byWordWrapping
        default :
            break
        }
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
