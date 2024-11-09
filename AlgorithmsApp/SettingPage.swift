import SwiftUI

struct SettingPage: View {
    var body: some View {
        List {
            Section("General") {
                NavigationLink(destination: SetSortDataSizePage()) {
                    Text("Set Data Size")
                }
            }
            Section("About developer") {
                Link("GitHub", destination: URL(string: "https://github.com/AnthonyQwO")!)
                Link("Medium", destination: URL(string: "https://medium.com/@anthonyqwo")!)
            }
        }
    }
}

struct SizeOptions: Identifiable, Equatable {
    let id = UUID()
    var option: String
    var size: Int
}

struct SetSortDataSizePage: View {
    
    @State private var selectedOption: SizeOptions? = nil
    
    let options: [SizeOptions] = [
        SizeOptions(option: "Small", size: 10),
        SizeOptions(option: "Medium", size: 30),
        SizeOptions(option: "Large", size: 60),
        SizeOptions(option: "Super Large", size: 100)
    ]
    
    var body: some View {
        Text("Set Data Size")
        List {
            ForEach(options) { option in
                HStack {
                    Text(option.option)
                    Spacer()
                    // 使用 Image 來表示勾選狀態
                    if selectedOption?.id == option.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // 讓整個行都可點擊
                .onTapGesture {
                    // 更新選中的項目
                    selectedOption = option
                    sz = option.size
                }
            }
        }
        .onAppear {
            for option in options {
                if sz == option.size {
                    selectedOption = option
                    break
                }
            }
            
        }
    }
}
#Preview {
    SettingPage()
}

