//
//  GeminiManager.swift
//  EasyMath
//
//  Created by Can on 15.03.2024.
//

import UIKit
import GoogleGenerativeAI
import Combine

final class GeminiManager {
    static let shared = GeminiManager()
    
    private init() { }
    
    func fetchMathQuestion(mathImage: UIImage, completion: @escaping (String) -> ()) async {
        let config = GenerationConfig(
          temperature: 0,
          topP: 0.95,
          topK: 20,
          candidateCount: 1,
          maxOutputTokens: 400
        )
        let model = GenerativeModel(name: "gemini-pro-vision", apiKey: "AIzaSyCceBEjjz9xq6MMTdTVe7Fs1xmZRcNMoKY", generationConfig: config)
        
        let prompt = "Resimde matematik sorusu var mı ? İlk önce onu incele. Eğer görselde matematik sorusu varsa matematik sorusunu çöz."
        
        do {
            
            let response = try await model.generateContent(prompt, mathImage)
            if let text = response.text {
                DispatchQueue.main.async {
                    print("text1: \(text)")
                    completion(text)
                }
            }
        } catch {
            print(error)
        }
    }
}


//let contentStream = model.generateContentStream(prompt, mathImage)
//for try await chunk in contentStream {
//  if let text = chunk.text {
//      DispatchQueue.main.async {
//          completion(text)
//      }
//  }
//}
