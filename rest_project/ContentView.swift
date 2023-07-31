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
