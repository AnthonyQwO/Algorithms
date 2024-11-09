import SwiftUI

struct Test: View {
    @State private var isFavorite = false

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Label("Activate Inbox Zero", systemImage: "mail.stack")
        }
        .symbolEffect(.bounce.down, value: isFavorite)
        .font(.largeTitle)
    }
}
#Preview {
    Test()
}
