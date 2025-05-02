import Foundation

struct AITip: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let relatedPlants: [String]
    let imagePrompt: String
}

class AITipService {
    private let apiKey = "YOUR_API_KEY_HERE"

    func fetchAITips(from acceptedPlants: [String], completion: @escaping ([AITip]) -> Void) {
        let prompt = """
        Given the user's accepted plants: \(acceptedPlants.joined(separator: ", ")), generate exactly 3 smart planting tips as a JSON array.

        Each object should have:
        - id (string, UUID)
        - title (string)
        - description (string)
        - relatedPlants (array of strings)
        - imagePrompt (string, one sentence that can be used for image generation)

        Respond only with a valid JSON array of tip objects.
        """

        let requestData: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=\(apiKey)"),
              let body = try? JSONSerialization.data(withJSONObject: requestData) else {
            print("❌ Failed to construct Gemini request")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print("❌ No response from Gemini:", error?.localizedDescription ?? "unknown")
                return
            }

            do {
                if let response = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = response["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {

                    print("🧠 Gemini raw text:\n\(text)")

                    if let tipsData = text.data(using: .utf8) {
                        let tips = try JSONDecoder().decode([AITip].self, from: tipsData)
                        DispatchQueue.main.async {
                            completion(tips)
                        }
                    } else {
                        print("❌ Failed to convert Gemini response to data")
                    }
                } else {
                    print("❌ Unexpected Gemini structure")
                    print(String(data: data, encoding: .utf8) ?? "N/A")
                }
            } catch {
                print("❌ Gemini decoding error:", error.localizedDescription)
                print(String(data: data, encoding: .utf8) ?? "N/A")
            }
        }.resume()
    }
}
