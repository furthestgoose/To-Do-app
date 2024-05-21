import Foundation
import SwiftData

@Model
final class Task{
    var title: String
    var date: Date
    var notes: String?
    var completed: Bool

    init(title: String, date: Date, notes: String? = nil, completed: Bool = false) {
        self.title = title
        self.date = date
        self.notes = notes
        self.completed = completed
    }
}
