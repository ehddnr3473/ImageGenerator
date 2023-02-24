//
//  ViewModel.swift
//  ImageGenerator
//
//  Created by 김동욱 on 2023/02/24.
//

import Foundation
import OpenAIKit
import UIKit

final class ViewModel: ObservableObject {
    @frozen enum Constants {
        static let key = ProcessInfo.processInfo.environment["API_KEY"]!
    }
    
    private var openAI: OpenAI?
    @Published var image: UIImage?
    
    func setUp() {
        openAI = OpenAI(Configuration(
            organization: "Personal",
            apiKey: Constants.key
        ))
    }
    
    func generateImage(prompt: String) async {
        guard let openAI = openAI else { return }
        
        do {
            let params = ImageParameters(
                prompt: prompt,
                resolution: .medium,
                responseFormat: .base64Json
            )
            let result = try await openAI.createImage(parameters: params)
            let imageData = result.data[0].image
            let image = try openAI.decodeBase64Image(imageData)
            self.image = image
        } catch {
            print(String(describing: error))
        }
    }
}
