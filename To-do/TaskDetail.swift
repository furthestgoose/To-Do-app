import SwiftUI
import SwiftData

struct TaskDetail: View {
    @Bindable var task: Task
    let isNew: Bool

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(task: Task, isNew: Bool = false) {
        self.task = task
        self.isNew = isNew
    }

    var body: some View {
        Form {
            TextField("Title", text: $task.title)
                .autocorrectionDisabled()
            DatePicker("Date and Time", selection: $task.date, displayedComponents: [.date, .hourAndMinute])
            Section(header: Text("Notes")) {
                TextEditor(text: $task.notes.bound)
                    .frame(height: 500)
                    .autocorrectionDisabled()
            }
        }
        .navigationTitle(isNew ? "New Task" : "Task")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(task)
                        dismiss()
                    }
                }
            }
        }
    }
}
extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue.isEmpty ? nil : newValue }
    }
}

