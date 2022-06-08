//
//  UserView.swift
//  GithubLookupCorrected
//
//  Created by Amos Deane on 08/06/2022.
//

import SwiftUI
import URLImage


struct UserView: View {
    
    @State var username: String
    @ObservedObject var fetchUsers = FetchUsers()
    @State private var searchText = ""
    
    
    var body: some View {
        
        ScrollView {
            Text("")
        }
        
        List {
            ForEach(fetchUsers.users, id:\.self) { user in
                NavigationLink(user.login, destination: UserDetailView(user:user))
            }
            .searchable(text: $searchText)
            
        }.onAppear {
            self.fetchUsers.search(for: username)
        }
    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
