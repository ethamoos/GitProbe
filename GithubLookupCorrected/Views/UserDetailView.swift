//
//  UserDetailView.swift
//  GithubLookupCorrected
//
//  Created by Amos Deane on 08/06/2022.
//

import SwiftUI
import URLImage


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


//
//
//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
