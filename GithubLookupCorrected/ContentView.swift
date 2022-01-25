//
//  ContentView.swift
//  GIthubLookupCorrected
//
//  Created by Amos Deane on 27/08/2021.
//

import SwiftUI
import URLImage




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

struct ContentView: View {
    @State var username: String = ""
    
    var body: some View {
        NavigationView {
             
            Form {
                Section {
                    Text("Enter user to search for")
                    TextField("Enter your username", text: $username).disableAutocorrection(true)
                        .autocapitalization(.none)

                }
                NavigationLink(destination: DetailView(username: $username)) {
                    Text("Show detail for \(username)")
                }
            }
        }
    }
}

struct DetailView: View {
    
    @Binding var username: String
    @ObservedObject var fetchUsers = FetchUsers()
    
    var body: some View {
        List {
            ForEach(fetchUsers.users, id:\.self) { user in
                NavigationLink(user.login, destination: UserDetailView(user:user))
            }
        }.onAppear {
            self.fetchUsers.search(for: username)
        }
        
    }
}

struct UserDetailView: View {
    
    var user: User
    
    var body: some View {
//        Link(destination: URL(string: user.html_url)!){
        Form {
            Text(user.login).font(.headline)
//            Text("Score = \(user.score)")
            Text("Git iD = \(user.id)")
//            Text("URL = \(user.url)")
            Text("Web Url = \(user.htmlURL)")
            Text("Repos Url = \(user.reposURL)")
//            Text("Avatar URL = \(user.avatarURL)")
            URLImage(URL(string:user.avatarURL)!){ image in
                image.resizable().frame(width: 50, height: 50)
            }
        }
    }
}


struct Result: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

