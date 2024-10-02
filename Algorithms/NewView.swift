import SwiftUI

// 包裝 UIImage 並使其符合 Identifiable 協議
struct IdentifiableImage: Identifiable {
    let id = UUID() // 給每個圖像一個唯一的 ID
    let image: UIImage
}

struct NewView: View {
    @State private var selectedImage: IdentifiableImage? = nil
    @State private var showAlert = false // 控制提示顯示的狀態
    @State private var alertMessage = "" // 提示消息內容
    
    let algorithm: AlgorithmInfo
    
    init(algorithm: AlgorithmInfo) {
        self.algorithm = algorithm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !algorithm.images.isEmpty {
                    TabView {
                        ForEach(0..<algorithm.images.count, id: \.self) { index in
                            Image(uiImage: algorithm.images[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .cornerRadius(25)
                                .padding(5)
                                .clipped()
                                .onTapGesture {
                                    // 點擊查看原圖，將 UIImage 包裝為 IdentifiableImage
                                    selectedImage = IdentifiableImage(image: algorithm.images[index])
                                }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(width: 300, height: 200)
                    .padding(.horizontal)
                    .sheet(item: $selectedImage) { identifiableImage in
                        ZoomableImageView(image: identifiableImage.image)
                    }
                }
                
                // Introduction Section
                VStack(alignment: .leading) {
                    Text("Introduction")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    Text(algorithm.introduction)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                // Complexity Section
                VStack(alignment: .leading) {
                    Text("Complexity")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    VStack {
                        HStack {
                            Image(systemName: "timer")
                            Text("Time")
                                .font(.title2)
                        }
                        .padding(.bottom)
                        Text(algorithm.timeComplexity)
                            .font(.title2)
                            .padding(.bottom)
                    }
                    
                    VStack {
                        HStack {
                            Image(systemName: "opticaldiscdrive")
                            Text("Space")
                                .font(.title2)
                        }
                        .padding(.bottom)
                        Text(algorithm.spaceComplexity)
                            .font(.title2)
                            .padding(.bottom)
                    }
                }
                
                // Sample Code Section
                VStack(alignment: .leading) {
                    Text("Sample Code")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    
                    ScrollView(.horizontal) {
                        Text(algorithm.code)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .frame(minWidth: 350, maxHeight: .infinity, alignment: .leading)
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = algorithm.code
                                }) {
                                    Text("Copy Code")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle(algorithm.name)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
