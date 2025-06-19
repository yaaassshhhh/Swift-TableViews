//
//  ViewController.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    var myStudentDataService : StudentDataFetcher = StudentDataService()
    var studentData : [Student] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel : UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBAction func sortStudentCells(_ sender: UIButton) {
        if sortButton.titleLabel?.text == "GPA"{
            sender.setTitle("4-0", for: .normal)
            studentData = studentData.sorted{ $0.gpa!  > $1.gpa!}
            reloadTableData()
        } else{
            sender.setTitle("GPA", for: .normal)
            studentData = studentData.sorted{ $0.gpa!  < $1.gpa!}
            reloadTableData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        setupHeaderAndLabel()
        loadStudentData()
        
    }
    
    private func reloadTableData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func loadStudentData(){
        Task{
            do {
                studentData = try await myStudentDataService.fetchStudentData()
                reloadTableData()
            } catch {
                print("\n Bad Call :- \n \(error)")
            }
        }
    }
    
   
    
    private func setupTableView(){
        self.tableView.register(UINib(nibName: "StudentTableViewCell", bundle: nil), forCellReuseIdentifier: "studentTableViewCell")
        self.tableView.register(StudentTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
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

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : StudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath) as? StudentTableViewCell{
            cell.configure(studentData[indexPath.row], delegate: self, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension HomeViewController: TableViewCellDelegate {
    
    func shortlistStudent(at index : IndexPath ) {
        studentData[index.row].isShortlisted = !(studentData[index.row].isShortlisted ?? false)
        if studentData[index.row].isShortlisted == true{
            
            if let studentName = studentData[index.row].name{
                popupAlert(for : studentName)
            } else {
                print("No Name Found")
            }
        }
        reloadTableData()
        
    }
    
    func popupAlert(for studentName : String){
        let refreshAlert = UIAlertController(title: "\(studentName) Shortlisted", message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Alert dipatched")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
