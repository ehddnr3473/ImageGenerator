//
//  ContentView.swift
//  ImageGenerator
//
//  Created by 김동욱 on 2023/02/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()
    @State var text = ""
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } else {
                Text("Type prompt to generate image!")
            }
            Spacer()
            TextField("Type prompt here...", text: $text)
                .padding()
            Button("Generate") {
                Task {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        await viewModel.generateImage(prompt: text)
                    }
                }
                text = ""
            }
        }
        .navigationTitle("Image Generator")
        .onAppear {
            viewModel.setUp()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
