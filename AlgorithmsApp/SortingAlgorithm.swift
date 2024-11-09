import Charts
import SwiftUI

struct SortingAlgorithm: View {
    
    init(sortType: String) {
        self.sortType = sortType
    }
    
    var input: [Int] {
        var array = [Int]()
        for i in 1...sz {
            array.append(i)
        }
        return array.shuffled()
    }
    
    @State var data = [Int]()
    @State var activeValue = 0
    @State var previousValue = 0
    @State var checkValue: Int?
    @State var showReset: Bool = false
    @State var hide: Bool = true
    @State var running: Bool = false
    @State var sortType: String
    @State var speed: Int = 30
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                    BarMark(x: .value("Position", index), y: .value("Value", item))
                        .foregroundStyle(getColor(value: item).gradient)
                }
            }
            .frame(width: 280, height: 250)
            .opacity(hide ? 1 : 0) // 使用 opacity 控制顯示/隱藏
            .animation(.easeInOut(duration: 0.5), value: hide) // 控制動畫效
            .animation(.easeInOut(duration: 0.5), value: activeValue)
            
            VStack {
                if !showReset {
                    Button("Sort it!") {
                        if !running {
                            Task {
                                running = true
                                showReset = false
                                
                                switch sortType {
                                case "bubbleSort":
                                    try await bubbleSort()
                                case "insertionSort":
                                    try await insertionSort()
                                case "selectionSort":
                                    try await selectionSort()
                                case "quickSort":
                                    try await quicksort(l: 0, r: data.count)
                                case "mergeSort":
                                    try await mergeSort(l: 0, r: data.count)
                                default:
                                    break
                                }
                                
                                activeValue = 0
                                previousValue = 0
                                speed = data.count >= 100 ? 10 : 30
                                
                                try await Task.sleep(for: .seconds(0.8))
                                for index in 0..<data.count {
                                    // beep(data[index])
                                    checkValue = data[index]
                                    try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
                                }
                                
                                speed = 30
                                running = false
                                showReset = true
                            }
                        }
                    }
                }
                if showReset {
                    Button("Reset") {
                        withAnimation {
                            hide = false
                        }
                        Task {
                            try await Task.sleep(for: .seconds(0.5)) // 控制消失的時間
                            data = input
                            activeValue = 0
                            previousValue = 0
                            checkValue = 0
                            showReset = false
                            withAnimation {
                                hide = true
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            data = input
        }
    }
    
    @MainActor
    func merge(l: Int, m: Int, r: Int) async throws {
        var temp = Array(data[l..<r])
        temp[m - l..<r - l].reverse()
        // data[m..<r].reverse()
        // try await Task.sleep(until: .now.advanced(by: .milliseconds(speed * (r - m))), clock: .continuous)
        var i = l, j = r - 1
        for k in l..<r {
            activeValue = temp[i - l]
            previousValue = temp[j - l]
            if temp[i - l] < temp[j - l] {
                data[k] = temp[i - l]
                i += 1
            } else {
                data[k] = temp[j - l]
                j -= 1
            }
            try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
            activeValue = 0
            previousValue = 0
        }
    }
    
    @MainActor
    func mergeSort(l: Int, r: Int) async throws {
        if l < r - 1 {
            let m = (l + r) / 2
            try await mergeSort(l: l, r: m)
            try await mergeSort(l: m, r: r)
            try await merge(l: l, m: m, r: r)
        }
    }
    
    @MainActor
    func partition(l: Int, r: Int) async throws -> Int {
        var i = l - 1
        for j in l..<r {
            if data[j] < data[r] {
                i += 1
                activeValue = data[i]
                previousValue = data[j]
                data.swapAt(i, j)
                try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
            }
            activeValue = 0
            previousValue = 0
        }
        i += 1
        activeValue = data[i]
        previousValue = data[r]
        data.swapAt(i, r)
        try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
        
        activeValue = 0
        previousValue = 0
        
        return i
    }
    
    @MainActor
    func quicksort(l: Int, r: Int) async throws {
        if l < r {
            let mid = try await partition(l: l, r: r - 1)
            try await quicksort(l: l, r: mid)
            try await quicksort(l: mid + 1, r: r)
        }
    }
    
    @MainActor
    func selectionSort() async throws {
        guard data.count > 1 else {
            return
        }
        
        for i in 0..<data.count - 1 {
            var smallest = i
            previousValue = data[i]
            
            for j in i + 1..<data.count {
                if data[smallest] > data[j] {
                    activeValue = data[j]
                    smallest = j
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
                }
            }
            
            if smallest != i {
                activeValue = data[i]
                previousValue = data[smallest]
                data.swapAt(smallest, i)
                try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
            }
        }
    }
    
    @MainActor
    func insertionSort() async throws {
        guard data.count >= 2 else {
            return
        }
        
        for i in 1..<data.count {
            for j in (1...i).reversed() {
                if data[j] < data[j - 1] {
                    activeValue = data[j - 1]
                    previousValue = data[j]
                    data.swapAt(j, j - 1)
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
                } else {
                    break
                }
            }
        }
    }
    
    @MainActor
    func bubbleSort() async throws {
        guard data.count >= 2 else {
            return
        }
        
        for i in 0..<data.count {
            for j in 0..<data.count - i - 1 {
                activeValue = data[j + 1]
                previousValue = data[j]
                
                if data[j] > data[j + 1] {
                    data.swapAt(j + 1, j)
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(speed)), clock: .continuous)
                }
            }
        }
    }
    
    func getColor(value: Int) -> Color {
        if let checkValue, value <= checkValue {
            return .green
        }
        
        if value == activeValue {
            return .green
        } else if value == previousValue {
            return .yellow
        }
        
        return .blue
    }
}
