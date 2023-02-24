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
    private var openAI: OpenAI?
    @Published var image: UIImage?
    
    func setUp() {
        guard let fileURL = Bundle.main.url(forResource: "APIKey", withExtension: "txt") else {
            print("APIKey.txt 파일을 찾을 수 없습니다.")
            return
        }
        do {
            let key = try String(contentsOf: fileURL, encoding: .utf8)
            print("API Key: \(String(describing: key))")
            
            openAI = OpenAI(Configuration(
                organization: "Personal",
                apiKey: key
            ))
            print("setUp을 성공했습니다.")
        } catch {
            print("API Key를 읽어오는 동안 에러가 발생했습니다. \(String(describing: error))")
        }
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
            DispatchQueue.main.async {
                self.image = image
            }
        } catch {
            print(String(describing: error))
        }
    }
}
