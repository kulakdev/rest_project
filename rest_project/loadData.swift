import SwiftUI
import Foundation

func loadData() async throws -> [Result] {
    
    let endpoint = "https://my-json-server.typicode.com/kulakdev/myJsonServer/posts"
    
    guard let url = URL(string: endpoint) else {
        throw APIERROR.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIERROR.invalidData
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Result].self, from: data)
    } catch {
        throw APIERROR.invalidData
    }
    
}
