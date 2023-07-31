import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var someID: Int
    var postName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        VStack{
            Text("Get request")
            List(results, id: \.someID) { item in
                VStack(alignment: .leading){
                    Text(item.postName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }
            .padding()
            .task{
                do{
                    results = try await loadData()
                } catch {
                    
                }
            }
            Text("Post request")
        }
    }
    
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
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum APIERROR: Error{
    case invalidURL
    case invalidData
    case taskError
}
