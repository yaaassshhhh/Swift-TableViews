//
//  ViewController.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 11/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    var myStudentDataService : StudentDataFetcher = StudentDataService()
    var studentData : [Student] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        setupHeaderAndLabel()
        Task{
            do {
                studentData = try await myStudentDataService.fetchStudentData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("\n Bad Call :- \n \(error)")
            }
        }
        
    }
    
    private func setupTableView(){
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "studentTableViewCell")
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

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath) as? TableViewCell{
            
            let student : Student = studentData[indexPath.row]
            cell.delegate = self
            cell.configure(student)
            cell.index = indexPath
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: TableViewCellDelegate {
    func shortlist(at index : IndexPath ) {
        studentData[index.row].isShortlisted = !(studentData[index.row].isShortlisted ?? false)
        if studentData[index.row].isShortlisted == true{
            
            if let studentName = studentData[index.row].name{
                let refreshAlert = UIAlertController(title: "\(studentName) Shortlisted", message: "", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Alert dipatched")
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            } else {
                print("No Name Found")
            }
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
       
    }
}
