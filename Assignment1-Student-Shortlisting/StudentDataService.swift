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
        guard let url = URL(string : urlString) else {
            throw URLError(.badURL)
        }
        
        let (data ,  _ ) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(Response.self , from : data)
        //JSONDecoder is used to convert the json data into Swift object of Response type
        
        return decodedResponse.students
    }
}
