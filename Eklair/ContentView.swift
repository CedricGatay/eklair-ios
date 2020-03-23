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
    @State var host: String = "Not connected"
    @State var message: String = ""
    @State var hashedMessage: String = ""
    
    let user = EklairUser(id:  UUID().uuidString)
    let logger = MessageLogger()
    let queue = DispatchQueue(label: "actorQueue", qos: .userInitiated)
    
    
    var body: some View {
        VStack{
            Text("\(host)").lineLimit(nil)
        Button(action: { self.test() }){
            Text("Run Eklair [BOOT]")
        }
            Button(action: { self.withActor() }){
                Text("Run Eklair [Actor]")
            }
            Button(action: { self.channel() }){
                Text("Run Eklair [Channel]")
            }
            TextField("Message", text: $message)
            Button(action: { self.hashMe() }){
                Text("Hash Message")
            }
            Text("Hashed value \(hashedMessage)")
        }

    }
    
    func withActor(){
        queue.async {
            self.logger.withActor { host in
                self.host = host
            }
        }
    }
    
    func channel(){
        queue.async {
            self.logger.channel()
        }
    }
    
    func hashMe(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let msg = MessageContainer(message: formatter.string(for: Date())!, counter: Int32(counter), identity: user)
        logger.log(msg: msg)
        
        queue.async {
            self.logger.test()
        }
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
            EklairApp.init().run()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
