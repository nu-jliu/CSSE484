//
//  ContentView.swift
//  Hello Button SwiftUI
//
//  Created by Jingkun Liu on 3/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var count = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.count -= 1
                    print("Decrement Button \(self.count)")
                } label: {
                    Text("Decrement").frame(maxWidth: .infinity)
                }
                
                Button {
                    self.count = 0
                    print("Reset Button \(self.count)")
                } label: {
                    Text("Reset").frame(maxWidth: .infinity)
                }
                
                Button {
                    self.count += 1
                    print("Increment Button \(self.count)")
                } label: {
                    Text("Increment").frame(maxWidth: .infinity)
                }
            }
        }
        
        
//        Label {
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
