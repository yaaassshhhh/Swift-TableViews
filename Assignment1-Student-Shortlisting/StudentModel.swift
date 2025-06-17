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

struct Student : Codable  {
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
    
    init(_ name: String,_ university: String, _ gpa: Double,_ skills: String) {
        self.name = name
        self.university = university
        self.gpa = gpa
        self.skills = skills
    }
    
    //    init(from decoder : Decoder) throws {
    //        let container = try decoder.container(keyedBy: OuterKeys.self)
    //        let innerContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .student)
    //        name = try innerContainer.decode(String.self , forKey : .name)
    //        gpa = try innerContainer.decode(Int.self , forKey : .gpa)
    //        university = try innerContainer.decode(String.self , forKey : .university)
    //        skills = try innerContainer.decode(String.self , forKey : .skills)
    //    }
}

//let urlString = "https://run.mocky.io/v3/bb3289ea-2131-4ade-bcb4-a06ed487120a"

protocol StudentDataFetcher {
    func fetchStudentData() async throws -> [Student]
}

