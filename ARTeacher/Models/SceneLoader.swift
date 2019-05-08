//
//  SceneLoader.swift
//  ARTeacher
//
//  Created by Евгений Соболь on 5/8/19.
//  Copyright © 2019 Eugene Sobol. All rights reserved.
//

import Foundation
import Zip

class SceneLoader {

    static let shared = SceneLoader()
    let session = URLSession.shared
    let host = "http://192.168.31.222:8000/"

    func checkModels(completion: @escaping (Result<[Scene], SceneLoaderError>) -> Void) {
        session.dataTask(with: URL(string: host + "check")!) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(.unknown))
            }
            if let data = data, let graph = try? JSONDecoder().decode(Graph.self, from: data) {
                print(graph)
                self.loadModels { result in
                    if result {
                        completion(.success(graph.scenes))
                    } else {
                        completion(.failure(.unknown))
                    }
                }
            } else {
                completion(.failure(.unknown))
            }
        }.resume()
    }

    func loadModels(completion: @escaping (Bool) -> Void) {
        session.downloadTask(with: URL(string: host + "data.zip")!) { url, response, error in
            if let error = error {
                print(error)
                completion(false)
            }
            if let url = url {
                self.copy(url)
                completion(true)
            }
        }.resume()
    }

    func copy(_ url: URL) {
        let newUrl = FileManager.default.applicationSupport.appendingPathComponent("data.zip")
        try? FileManager.default.removeItem(at: newUrl)
        try! FileManager.default.copyItem(at: url, to: newUrl)
        print(newUrl)
        unzip(newUrl)
    }

    func unzip(_ url: URL) {
        try! Zip.unzipFile(url, destination: FileManager.default.applicationSupport, overwrite: true, password: nil)
    }

    struct Graph: Decodable {
        let version: Int
        let scenes: [Scene]
    }

    enum SceneLoaderError: Error {
        case unknown
    }
}