//
//  FetchUsers.swift
//  GithubLookupCorrected
//
//  Created by Amos Deane on 08/06/2022.
//

import Foundation



class FetchUsers: ObservableObject {
    @Published var users = [User]()
    
    func search(for user:String) {
        var urlComponents = URLComponents(string: "https://api.github.com/search/users")!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: user)]
        guard let url = urlComponents.url else {
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let data = data {
                    let decodedData = try JSONDecoder().decode(Result.self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedData.items
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}
