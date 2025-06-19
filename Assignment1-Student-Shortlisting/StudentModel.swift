//
//  StudentModel.swift
//  Assignment1-Student-Challenge
//
//  Created by Yash Agrawal on 11/06/25.
//

//
import Foundation

struct Response : Decodable{
    var students : [Student]
}

struct Student : Decodable  {
    var id : UUID = UUID()
    var name : String?
    var university : String?
    var gpa : Double?
    var skills : String?
    var isShortlisted : Bool?  = false
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case university =  "university"
        case gpa = "gpa"
        case skills =    "skills"
    }
}


protocol StudentDataFetcher {
    func fetchStudentData() async throws -> [Student]
}

