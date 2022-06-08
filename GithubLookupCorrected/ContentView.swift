import SwiftUI
import URLImage


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

struct User: Codable, Hashable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
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
                NavigationLink(destination: UserView(username: username)) {
                    Text("Show detail for \(username)")
                }
            }
        }
    }
}

struct UserView: View {
    
    @State var username: String
    @ObservedObject var fetchUsers = FetchUsers()
    @State var searchText = ""
    
    var body: some View {
        List {
            ForEach(fetchUsers.users, id:\.self) { user in
                NavigationLink(user.login, destination: UserDetailView(user:user))
            }
        }.onAppear {
            self.fetchUsers.search(for: username)
        }
        .searchable(text: $searchText)
        .navigationTitle("Users")
        
    }
    
    /// The search results
//    private var searchResults: [User] {
//        if searchText.isEmpty {
//            return fetchUsers.users // your entire list of users if no search input
//        } else {
//            return fetchUsers.search(for: searchText) // calls your search method passing your search text
//        }
//    }
}

struct UserDetailView: View {
    
    var user: User
    
    var body: some View {
        Form {
            Text(user.login).font(.headline)
            Text("Git iD = \(user.id)")
            URLImage(URL(string:user.avatarURL)!){ image in
                image.resizable().frame(width: 50, height: 50)
            }
        }
    }
}


