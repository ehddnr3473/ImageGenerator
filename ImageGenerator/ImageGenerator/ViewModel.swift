//
//  ViewModel.swift
//  ImageGenerator
//
//  Created by 김동욱 on 2023/02/24.
//

import Foundation
import OpenAIKit

final class ViewModel: ObservableObject {
    @frozen enum Constants {
        static let key = Bundle.main.infoDictionary?["API_KEY"] as! String
    }
    
    private var openAI: OpenAI?
    
    func setUp() {
        openAI = OpenAI(Configuration(
            organization: "Personal",
            apiKey: Constants.key
        ))
    }
}
