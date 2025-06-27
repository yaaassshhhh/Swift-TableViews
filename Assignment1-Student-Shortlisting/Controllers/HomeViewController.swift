//
//  ViewController.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit
import SkeletonView

protocol HomeViewControllerDelegate: AnyObject {
    func loadTableData()
}
class HomeViewController: UIViewController {

    
    
    var homeVM : HomeViewModel = HomeViewModel()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerLabel : UILabel!
    
    @IBOutlet weak var studentSearchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBAction func sortStudentCells(_ sender: UIButton) {
        if sortButton.titleLabel?.text == "GPA"{
            sender.setTitle("4-0", for: .normal)
            homeVM.sortByGpaDesc()
            reloadTableData()
        } else if sortButton.titleLabel?.text == "4-0"  {
            sender.setTitle("0-4", for: .normal)
            homeVM.sortByGpaAsc()
            reloadTableData()
        } else {
            sender.setTitle("4-0", for: .normal)
            
            homeVM.sortByGpaDesc()
            reloadTableData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        setupHeaderAndLabel()
        setupSearchBar()
        loadStudentData()
    }

    private func reloadTableData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func loadStudentData(){
        self.showSkeleton()
        self.homeVM.loadStudentData(delegate : self)
            DispatchQueue.main.async(){
                self.hideSkeleton()
                self.reloadTableData()
            }
        }
    
    private func showSkeleton(){
        let gradient = SkeletonGradient(baseColor: UIColor.silver)
        tableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil, transition: .crossDissolve(0.50))
    }
    
    private func hideSkeleton(){
        self.tableView.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true)
    }
    private func setupTableView(){
        tableView.isSkeletonable = true
        self.tableView.register(UINib(nibName: "StudentTableViewCell", bundle: nil), forCellReuseIdentifier: "studentTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        studentSearchBar.delegate = self
    }
    
    private func setupHeaderAndLabel() {
        headerLabel.text = "Student Shortlisting Challenge"
        headerLabel.backgroundColor = .white
        
        self.title = "WWDC 2025"
        self.headerLabel.textColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
    }
    
}

extension HomeViewController : SkeletonTableViewDataSource, UITableViewDelegate {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeVM.numberOfRows(inSection: section)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "studentTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : StudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath) as? StudentTableViewCell{
            cell.configure(homeVM.getStudentCellViewModel(at: indexPath), delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension HomeViewController : TableViewCellDelegate {
    
    func presentShareProfileActivity( for url: URL, activityController: UIActivityViewController) {
        present(activityController, animated: true, completion: {
            print("Profile Shared Successfully")
        })
    }
    
    
    func shortlistStudent(_ shouldPopup : Bool , for studentName : String) {

        if shouldPopup{
            self.popupAlert(for : studentName)
        } else {
            print("No Name Found")
        }
        reloadTableData()
    }
    
    private func popupAlert(for studentName : String){
        
        let refreshAlert = UIAlertController(title: "\(studentName) Shortlisted", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in
            print("Alert dipatched")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}

extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeVM.initializeSearch(for: searchText)
        self.reloadTableData()
    }
}

extension HomeViewController : HomeViewControllerDelegate{
    func loadTableData() {
        self.reloadTableData()
    }
}
