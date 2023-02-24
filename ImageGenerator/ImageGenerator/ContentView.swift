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
    @State var isGenerating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                    } else {
                        Text("Type prompt to generate image!")
                    }
                    
                    Spacer()
                    
                    TextField("Type prompt here...", text: $text)
                        .padding()
                        .foregroundColor(.black)
                    
                    Button("Generate") {
                        Task {
                            if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                                isGenerating = true
                                await viewModel.generateImage(prompt: text)
                                text = ""
                                isGenerating = false
                            }
                        }
                    }
                    .disabled(isGenerating)
                }
                .navigationTitle("Image Generator")
                .foregroundColor(.pink)
                .onAppear {
                    viewModel.setUp()
                }
                .padding()
                
                if isGenerating {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.pink)
                        .scaleEffect(2)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
