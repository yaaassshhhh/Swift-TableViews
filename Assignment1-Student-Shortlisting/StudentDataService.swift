//
//  StudentDataController.swift
//  Assignment1-Student-Challenge
//
//  Created by Yash Agrawal on 11/06/25.
//

import Foundation

class StudentDataService : StudentDataFetcher{
    
    let urlString = "https://run.mocky.io/v3/bb3289ea-2131-4ade-bcb4-a06ed487120a"
    func fetchStudentData() async throws -> [Student] {
        let url = URL(string : urlString)!
        let (data ,  _ ) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(Response.self , from : data) // this line is to decode a=JSON data into a SWIFT Obj
        // basically iot converted raw json data into a Response object type
        //JSONDecoder converts the json data into Swift object
        //Response.self i.e the first arguement to decode is the object type that(2nd arguement) data needs to be converted to
        
        return decodedResponse.students
    }
}
