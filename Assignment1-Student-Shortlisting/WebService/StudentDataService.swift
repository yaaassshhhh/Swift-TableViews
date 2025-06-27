//
//  StudentDataController.swift
//  Assignment1-Student-Challenge
//
//  Created by Yash Agrawal on 11/06/25.
//

import Foundation

class StudentDataService {
    
    func getStudentData(completion : @escaping ([Student]?) ->() ){
        let urlString = "https://demo9847086.mockable.io/student"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){ (data , _ , error) in
            if let error = error {
                print("Error : \(error)")
                completion(nil)
                return
            } else if let data = data {
                let studentResponse = try? JSONDecoder().decode(Response.self , from : data)
                completion(studentResponse?.students)
            }            
        }.resume()
    }
}
