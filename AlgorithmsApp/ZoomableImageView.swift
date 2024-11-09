import SwiftUI

struct ZoomableImageView: View {
    var image: UIImage
    @GestureState private var magnification: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode
    
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 5.0
    private let dragMultiplier: CGFloat = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.8) // 半透明黑色背景
                    .ignoresSafeArea()
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(min(max(finalScale * magnification, minScale), maxScale)) // 設定縮放限制
                    .offset(x: offset.width, y: offset.height) // 設置偏移來實現平移
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .updating($magnification) { value, state, _ in
                                    state = value
                                }
                                .onEnded { value in
                                    let newScale = finalScale * value
                                    finalScale = min(max(newScale, minScale), maxScale) // 更新縮放並設置邊界
                                    offset = .zero // 縮放時重置偏移
                                },
                            DragGesture()
                                .onChanged { value in
                                    // 計算新的偏移量
                                    let newOffset = CGSize(
                                        width: value.translation.width * dragMultiplier + offset.width,
                                        height: value.translation.height * dragMultiplier + offset.height
                                    )
                                    // 計算當前圖像的大小
                                    let imageWidth = image.size.width * finalScale
                                    let imageHeight = image.size.height * finalScale
                                    
                                    // 計算邊界
                                    let xBoundary = (imageWidth - geometry.size.width) / 2
                                    let yBoundary = (imageHeight - geometry.size.height) / 2
                                    
                                    // 確保偏移量在邊界內
                                    offset.width = min(max(newOffset.width, -xBoundary), xBoundary)
                                    offset.height = min(max(newOffset.height, -yBoundary), yBoundary)
                                }
                                .onEnded { _ in
                                    // 在拖動結束時實現回彈效果
                                    withAnimation {
                                        let imageWidth = image.size.width * finalScale
                                        let imageHeight = image.size.height * finalScale
                                        
                                        let xBoundary = (imageWidth - geometry.size.width) / 2
                                        let yBoundary = (imageHeight - geometry.size.height) / 2
                                        
                                        offset.width = min(max(offset.width, -xBoundary), xBoundary)
                                        offset.height = min(max(offset.height, -yBoundary), yBoundary)
                                    }
                                }
                        )
                    )
                    .padding()
                    .navigationBarItems(trailing: Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    })
                    .onTapGesture(count: 2) {
                        // 雙擊縮放圖像
                        finalScale = finalScale == minScale ? maxScale : minScale
                        offset = .zero // 縮放時重置偏移
                    }
            }
        }
        .animation(.easeInOut, value: finalScale) // 平滑縮放動畫
    }
}
