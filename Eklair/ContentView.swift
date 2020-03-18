//
//  ContentView.swift
//  Eklair
//
//  Created by Cedric Gatay on 16/03/2020.
//  Copyright © 2020 Code-Troopers. All rights reserved.
//

import SwiftUI
import eklair_node

struct ContentView: View {
    var body: some View {
        VStack{
        Text("Hello, World!")
            Button(action: { self.test() }){
                Text("Run Eklair")
            }
        }
    }
    
    func test() {
        Eklair.init().run()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
