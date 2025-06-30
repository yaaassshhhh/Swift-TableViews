//
//  StudentCellViewModel.swift
//  Assignment1-Student-Shortlisting
//
//  Created by Yash Agrawal on 24/06/25.
//

import Foundation

class HomeViewModel{
    private var allStudents: [StudentCellViewModel] = []
    private var filterStudents:[StudentCellViewModel] = []
    private var delegate : HomeViewControllerDelegate?
}

class StudentCellViewModel {
    var student : Student
    var isShortlisted : Bool = false
    
    init(student: Student) {
        self.student = student
    }
}

extension HomeViewModel{
    
    var numberOfSection : Int{
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return self.filterStudents.count
    }
    
    func loadStudentData(delegate: HomeViewControllerDelegate?) {
        self.delegate = delegate
           StudentDataService().getStudentData() { students in
               guard let students  =  students else { return }
               self.updateStudents(students)
               delegate?.loadTableData()
        }
       
    }

    func updateStudents(_ students: [Student]) {
        self.allStudents = students.map({ StudentCellViewModel(student: $0) })
        self.filterStudents = self.allStudents
    }
    
    func getStudentCellViewModel(at indexPath: IndexPath) -> StudentCellViewModel {
        let cellVM = self.filterStudents[indexPath.row]
        return cellVM
        
    }
    
     func sortByGpaDesc(){
//         guard let gpa = self.filterStudents.first?.student.gpa else { return }
         self.filterStudents = self.filterStudents.sorted{ $0.gpa > $1.gpa }
    }
     func sortByGpaAsc(){
         self.filterStudents = self.filterStudents.sorted{ $0.gpa < $1.gpa }
    }
    
     func initializeSearch(for searchText: String){
        self.filterStudents = []
        if searchText.isEmpty{
            self.filterStudents = self.allStudents
        }else{
            self.filterStudents = self.allStudents.filter{$0.student.name?.lowercased().contains(searchText.lowercased()) ?? false}
        }
    }
    
     func shortlistStudent(at index: IndexPath) -> Bool {
        
         self.filterStudents[index.row].toggleShortlist()
        updateAllStudents(at : index)
        return filterStudents[index.row].isShortlisted
    }
    
     func updateAllStudents(at index : IndexPath) {
        if let originalIndex = self.allStudents.firstIndex(where: { $0.id == self.filterStudents[index.row].id }) {
            self.allStudents[originalIndex].toggleShortlist()
        }
    }
    
}
extension StudentCellViewModel{
    
    var name : String{
        return self.student.name ?? ""
    }
    
    var skills : String{
        return self.student.skills ?? ""
    }
    
    var university:String{
        return self.student.university ?? ""
    }
    var gpa : Double{
        return self.student.gpa ?? 0.0
    }
    
    var id : UUID{
        return self.student.id
    }
    
     func toggleShortlist(){
        self.isShortlisted = !(self.isShortlisted )
    }
    
    var genURL : URL?{
        guard let name = whiteSpaceRemover(text: self.student.name) else { return nil }
        return URL(string: "https://github.com/\(name)")
    }
    private func whiteSpaceRemover(text : String?) -> String? {
        guard let text = text else { return nil }
        return text.replacingOccurrences(of: " ", with: "")
    }
}
