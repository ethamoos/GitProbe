//
//
//  This is an extension of an exercise is Greg Lim's book Beginning Swift UI https://www.amazon.com/Beginning-SwiftUI-Greg-Lim-ebook/dp/B08XV4NPDP
// Thanks to those on StackOverflow for help making it work - https://stackoverflow.com/questions/68949231/issue-with-defining-a-variable-via-a-textfield-and-then-passing-it-to-an-observe
//

import SwiftUI
import URLImage




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
