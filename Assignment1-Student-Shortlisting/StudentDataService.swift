//
//  StudentDataController.swift
//  Assignment1-Student-Challenge
//
//  Created by Yash Agrawal on 11/06/25.
//

import Foundation
protocol StudentDataFetcher {
    func fetchStudentData() async throws -> [Student]
}

class StudentDataService : StudentDataFetcher{
    
//    let urlString : String = "https://run.mocky.io/v3/bb3289ea-2131-4ade-bcb4-a06ed487120a"
    let urlString : String = "https://demo9847086.mockable.io/student"
    func fetchStudentData() async throws -> [Student] {
        guard let url : URL = URL(string : urlString) else {
            throw URLError(.badURL)
        }
        return try await getResponseData(for : url).students
    }
    
    func getResponseData(for url : URL) async throws -> Response {
        
        let (data , _) = try await URLSession.shared.data(from: url)
        let decodedResponse : Response = try JSONDecoder().decode(Response.self , from : data)
        return decodedResponse
    }
}
