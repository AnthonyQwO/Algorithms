import SwiftUI

struct AlgorithmInfo: Decodable {
    let name: String
    let introduction: String
    let code: String
    let bio: String
    let icon: String
    let timeComplexity: String
    let spaceComplexity: String
    let images: [String]
    let isSort: String
    
    init(name: String = "Title", introduction: String = "context", code: String = "printf(\"Hello World!\");", bio: String = "short bio", icon: String = "pencil.circle", timeComplexity: String = "None", spaceComplexity: String = "None", images: [String] = [], isSort: String = "false") {
        self.name = name
        self.introduction = introduction
        self.code = code
        self.bio = bio
        self.icon = icon
        self.timeComplexity = timeComplexity
        self.spaceComplexity = spaceComplexity
        self.images = images
        self.isSort = isSort
    }
}

struct AlgorithmSection {
    var title: String
    var algorithms: [AlgorithmInfo] // Replace String with the actual type if different
    var color: Color
    var path: String
}

struct MainPageView: View {
    func loadAlgorithmData(path: String, algorithm: inout [AlgorithmInfo]) {
        // Get the path of the JSON file in the main bundle
        if let url = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                // Load the data from the file
                let data = try Data(contentsOf: url)
                
                // Decode the data into an array of AlgorithmInfo
                algorithm = try JSONDecoder().decode([AlgorithmInfo].self, from: data)
                
                // Successfully loaded the data
                // print("Successfully loaded algorithms")
            } catch {
                // Handle errors
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }
    
    @State var sortAlgorithm: [AlgorithmInfo] = [AlgorithmInfo()]
    @State var stringAlgorithm: [AlgorithmInfo] = [AlgorithmInfo()]
    @State var datastructureAlgorithm: [AlgorithmInfo] = [AlgorithmInfo()]
    @State var graphAlgorithm: [AlgorithmInfo] = [AlgorithmInfo()]
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        @State var sections = [
            ("Sort Algorithms", sortAlgorithm, Color.green, "sort"),
            ("String Algorithms", stringAlgorithm, Color.orange, "string"),
            ("Datastructures", datastructureAlgorithm, Color.blue, "datastructure"),
            ("Graph Algorithms", graphAlgorithm, Color.red, "graph")
        ]
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sections, id: \.0) { (title, algorithms, color, path) in
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title)
                            .padding()
                            .bold()
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: columns, spacing: 20) {
                                ForEach(algorithms, id: \.name) { algorithm in
                                    NavigationLink(destination: NewView(algorithm: algorithm)) {
                                        VStack(alignment: .leading, spacing: 30) {
                                            Image(systemName: algorithm.icon)
                                            Text(algorithm.name)
                                        }
                                        .padding()
                                        .frame(width: 150, height: 100, alignment: .leading)
                                        .background(.ultraThinMaterial)
                                        .background(color)
                                        .cornerRadius(25)
                                        .foregroundColor(.white)
                                        .contextMenu {
                                            Text(algorithm.bio)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Algorithms")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear() {
            loadAlgorithmData(path: "string", algorithm: &stringAlgorithm)
            loadAlgorithmData(path: "datastructure", algorithm: &datastructureAlgorithm)
            loadAlgorithmData(path: "graph", algorithm: &graphAlgorithm)
            loadAlgorithmData(path: "sort", algorithm: &sortAlgorithm)
//                for i in 0..<sections.count {
//                    loadAlgorithmData(path: sections[i].3, algorithm: &sections[i].1)
//                }
        }
    }
}

#Preview {
    MainPageView()
}

