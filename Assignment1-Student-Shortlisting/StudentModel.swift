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

struct Student : Decodable {
    var name : String
    var university : String
    var gpa : Double
    var skills : String
    var isShortlisted : Bool?  = false

    init(_ name: String,_ university: String, _ gpa: Double,_ skills: String) {
        self.name = name
        self.university = university
        self.gpa = gpa
        self.skills = skills
    }
}

//let urlString = "https://run.mocky.io/v3/bb3289ea-2131-4ade-bcb4-a06ed487120a"

protocol StudentDataFetcher {
    func fetchStudentData() async throws -> [Student]
}

