import SwiftUI

struct PickerView: View {
    @Binding var isGridView: Bool
    let imageTrue: Image
    let imageFalse: Image
    let labelTrue: String
    let labelFalse: String

    var body: some View {
        Picker(selection: $isGridView, label: Text("")) {
            imageTrue
                .tag(true)
                .accessibilityLabel(labelTrue)
            imageFalse
                .tag(false)
                .accessibilityLabel(labelFalse)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
