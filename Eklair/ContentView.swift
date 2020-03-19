//
//  ContentView.swift
//  Eklair
//
//  Created by Cedric Gatay on 16/03/2020.
//  Copyright © 2020 Code-Troopers. All rights reserved.
//

import SwiftUI
import eklair_node

var counter = 0

struct ContentView: View {
    @State var message: String = ""
    @State var hashedMessage: String = ""
    
    let user = EklairUser(id: Uuid().fromString(s: UUID().uuidString))
    let logger = MessageLogger()
    
    
    var body: some View {
        VStack{
        Text("Hello, World!")
        Button(action: { self.test() }){
            Text("Run Eklair")
        }
            TextField("Message", text: $message)
            Button(action: { self.hashMe() }){
                Text("Hash Message")
            }
            Text("Hashed value \(hashedMessage)")
        }

    }
    
    func hashMe(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let msg = MessageContainer(message: formatter.string(for: Date())!, counter: Int32(counter), identity: user)
        logger.log(msg: msg)
        logger.nativeLog {
            NSLog("Swifty logging")
            return "Swift string \(type(of: self))"
        }
        counter += 1
        hashedMessage = EklairDTO(message: message).hashValues()
        
    }
    
    func test() {
        let queue = DispatchQueue.init(label: "Eklair", qos: .background)
        queue.async {
            Eklair.init().run()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
