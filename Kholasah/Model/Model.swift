import Foundation

struct Meeting: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: String
    var time: String
    var duration: String
}
