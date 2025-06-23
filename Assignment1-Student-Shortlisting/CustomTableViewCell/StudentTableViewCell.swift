//
//  TableViewCell.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

protocol TableViewCellDelegate:  AnyObject {
    func shortlistStudent(at index : IndexPath)
    func presentShareProfileActivity(at index : IndexPath , for url : URL , of name : String , activityController : UIActivityViewController)
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
    
    @IBOutlet weak var sharePopUpButton: UIButton!
    @IBOutlet weak var shortlistButton : UIButton!
    @IBOutlet weak var universityHeigh :  NSLayoutConstraint!
    @IBOutlet weak var nameValyeHeight :  NSLayoutConstraint!
    
    
    private weak var delegate: TableViewCellDelegate?
    private  var data: Student?
    private var index : IndexPath?
    
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        print("awakeFromNib triggered")
    //        print("Button Frame: \(sharePopUpButton.frame)")
    //
    //    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        setSharePopUpButton()
    //    }
    
    @IBAction func shortlistTapped(_ sender: UIButton)  {
        print("Shortlist tapped")
        delegate?.shortlistStudent(at : self.index!)
//        configureButtonStyle()
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
        guard var name = self.data?.name as? String else { return }
        name = name.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "https://github.com/\(name)") else { return }
        
        let shareSelected = {(action : UIAction) in
            print("Profile Share Selected")
            let message  = ["Github Profile :\(url)" , "Check out this profile : \(name)"]
            let ac = UIActivityViewController(activityItems : message, applicationActivities: nil)
            self.delegate?.presentShareProfileActivity(at: self.index!, for: url ,of: name, activityController: ac)
        }
        let githubProfileSelected = {(action : UIAction) in
            UIApplication.shared.open(url ){ accepted in
                print(accepted ? "Success" : "Failure")
            }
        }
        
        sharePopUpButton.menu = UIMenu(
            children : [
                UIAction(title : "View Github", image: githubImage, handler: githubProfileSelected ),
                UIAction(title : "Share Profile", image: profileImage, handler:shareSelected)
            ]
        )
        
    }
    
    private func whiteSpaceRemover(text : String?) -> String? {
        guard let text = text else { return nil }
        return text.replacingOccurrences(of: " ", with: "")
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
    
    private func configureButtonStyle() {
        if data?.isShortlisted  == true{
            shortlistButton.tintColor  = UIColor.systemGray
//            shortlistButton.backgroundColor = UIColor.systemGray6

            print("\n \n Reaching here \n \n")
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
        labelKey.lineBreakMode = .byCharWrapping
        labelValue.numberOfLines = 0
        
        switch text {
        case "Name: " :
            labelValue.text = data?.name!
            labelValue.lineBreakMode = .byCharWrapping
            break
        case "Gpa: " :
            labelValue.text = String(format : "%.2f",data?.gpa ?? 0.0)
            labelValue.lineBreakMode = .byCharWrapping
        case "University: " :
            labelValue.text = data?.university!
            labelValue.lineBreakMode = .byWordWrapping
        case "Skills: " :
            labelValue.text = data?.skills!
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
