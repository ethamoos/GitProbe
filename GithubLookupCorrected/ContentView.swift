//
//  ContentView.swift
//  GIthubLookupCorrected
//
//  Created by Amos Deane on 27/08/2021.
//

import SwiftUI
import URLImage

// MARK: - User
struct User: Codable, Hashable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    let score: Int

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case score
    }
}


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
            Text("Score = \(user.score)")
            Text("ID = \(user.id)")
            Text("URL = \(user.url)")
            Text("htmlURL = \(user.htmlURL)")
            Text("reposURL = \(user.reposURL)")
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

