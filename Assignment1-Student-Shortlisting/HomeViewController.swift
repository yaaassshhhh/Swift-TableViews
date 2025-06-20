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
    var filterStudent : [Student] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel : UILabel!
    
    @IBOutlet weak var studentSearchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBAction func sortStudentCells(_ sender: UIButton) {
        if sortButton.titleLabel?.text == "GPA"{
            sender.setTitle("4-0", for: .normal)
            filterStudent = filterStudent.sorted{ $0.gpa!  > $1.gpa!}
            reloadTableData()
        } else if sortButton.titleLabel?.text == "4-0"  {
            sender.setTitle("0-4", for: .normal)
            filterStudent = filterStudent.sorted{ $0.gpa!  < $1.gpa!}
            reloadTableData()
        } else {
            sender.setTitle("4-0", for: .normal)
            filterStudent = filterStudent.sorted{ $0.gpa!  > $1.gpa!}
            reloadTableData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadStudentData()
        setupHeaderAndLabel()
        setupSearchBar()
        setupTableView()
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
                filterStudent = studentData
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
    
    private func setupSearchBar() {
        studentSearchBar.delegate = self
        filterStudent = studentData
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
        return filterStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : StudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath) as? StudentTableViewCell{
            cell.configure(filterStudent[indexPath.row], delegate: self, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension HomeViewController: TableViewCellDelegate {
    func presentShareProfileActivity(at index: IndexPath, for url: URL,  of name  : String , activityController: UIActivityViewController) {
        present(activityController, animated: true, completion: {
            print("\(name) Profile Shared Successfully")
        })
    }
    
    
    func shortlistStudent(at index : IndexPath ) {
        filterStudent[index.row].isShortlisted = !(filterStudent[index.row].isShortlisted ?? false)
        updateStudentData(at: index)
        if filterStudent[index.row].isShortlisted == true{
            
            if let studentName = filterStudent[index.row].name{
                popupAlert(for : studentName)
            } else {
                print("No Name Found")
            }
        }
        reloadTableData()
        
    }
    
    private func updateStudentData(at index : IndexPath){
        if let originalIndex = studentData.firstIndex(where: { $0.id == filterStudent[index.row].id }) {
            studentData[originalIndex].isShortlisted = filterStudent[index.row].isShortlisted
        }
    }
    
    private func popupAlert(for studentName : String){
        
        let refreshAlert = UIAlertController(title: "\(studentName) Shortlisted", message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Alert dipatched")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}

extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterStudent = []
        if searchText.isEmpty{
            filterStudent = studentData
        }
        for student in studentData {
            if student.name?.uppercased().contains(searchText.uppercased()) ?? false{
                filterStudent.append(student)
            }
        }
        self.reloadTableData()
    }
}
