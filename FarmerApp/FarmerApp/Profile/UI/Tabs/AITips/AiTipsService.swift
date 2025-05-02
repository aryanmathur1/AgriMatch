//
//  AiTipsService.swift
//  FarmerApp
//
//  Created by Aryan Mathur on 4/30/25.
//

import Foundation

struct AITipsService {
    
    func generatePlantingTips(from plantNames: [String], completion: @escaping ([String]) -> Void) {
        
        let prompt = buildPrompt(from: plantNames)
        
        let APIKeyGemini = GeminiAPI.GeminiAPIKey
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key="+APIKeyGemini) else {
            completion([])
            return
        }
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = responseJSON["candidates"] as? [[String: Any]],
                  let text = candidates.first?["content"] as? [String: Any],
                  let parts = text["parts"] as? [[String: Any]],
                  let generatedText = parts.first?["text"] as? String
            else {
                completion([])
                return
            }
            
            // Split AI response into tips (assuming each tip is on its own line)
            let tips = generatedText.components(separatedBy: "\n").filter { !$0.isEmpty }
            completion(tips)
            
        }.resume()
    }
    
    private func buildPrompt(from plantNames: [String]) -> String {
        let list = plantNames.joined(separator: ", ")
        return """
        I have these plants in my garden: \(list). 
        Suggest 15 personalized planting tips including:
        - Good companion plants.
        - Care advice they all share.
        - One plant to consider removing.
        - One new plant to consider adding.
        - What climate fertilizer to use.
        - Best harvest times.
        - Irrigation techniques
        - Pest Control
        Format each tip as a separate bullet point.
        """
    }
}
