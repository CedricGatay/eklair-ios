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
    
    let group = DispatchGroup()
    @State var msg: EklairActorMessage?
    @State var nextMsg : Any?
    @State var counter = 0
    
    var body: some View {
        VStack{
            Text("\(host)").lineLimit(nil).padding(.all)
            Button(action: withActor){
                Text("Run Eklair [Actor]")
            }
            Button(action: next){
                Text("Next action")
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
            self.logger.withActor { msg in
                if let response = msg as? HostResponseMessage{
                    self.host = "Connected to \(response.response)"
                    return EklairObjects().none
                }
                print("Entering group")
                self.group.enter()
                self.msg = msg
                self.group.wait(wallTimeout: .now() + 0.1)
                
                let response = self.nextMsg ?? EklairObjects().none
                self.nextMsg = nil
                return response
            }
        }
    }
    
    func next() {
        if !self.host.contains("@") {
            nextMsg = EklairObjects().hostMsg
        }else{
            counter+=1
            if counter >= 30 {
                nextMsg = EklairObjects().disconnect
            }else{
                nextMsg = EklairObjects().ping
            }
        }
        self.group.leave()
    }
    
    
    /*
     Unused for the time being, to launch eclair using a basic channel impl
     */
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
    
    /*
     Unused for the time being, "old" boot launch
     */
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
