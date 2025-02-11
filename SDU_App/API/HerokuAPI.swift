//
//  HerokuAPI.swift
//  SDU App
//
//  Created by Nurkhat on 26.11.2024.
//

//import Foundation
//
//class HerokuAPI {
//    static let shared = HerokuAPI()
//    private let baseURL = "https://your-heroku-app.herokuapp.com/schedule" // Замените на ваш URL
//
//    func fetchScheduleData(completion: @escaping (Result<[Course], Error>) -> Void) {
//        guard let url = URL(string: baseURL) else {
//            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
//                  let data = data else {
//                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
//                return
//            }
//
//            do {
//                let courses = try JSONDecoder().decode([Course].self, from: data)
//                completion(.success(courses))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
