import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var tasks: [Task]
    @State private var newTask: Task?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !tasks.isEmpty {
                    List {
                        ForEach(tasks.sorted(by: { $0.date < $1.date })) { task in
                            NavigationLink(destination: TaskDetail(task: task)) {
                                HStack {
                                    Button(action: { toggleTaskCompletion(task) }) {
                                        Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .font(.headline)
                                            .foregroundColor(task.completed ? .gray : .primary)
                                            .strikethrough(task.completed)
                                        
                                        Text("\(task.date.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Tasks", systemImage: "checklist")
                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTask) {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newTask) { task in
                NavigationStack {
                    TaskDetail(task: task, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a Task")
                .navigationTitle("Task")
        }
    }
    
    private func addTask() {
        withAnimation {
            let newTask = Task(title: "New Task", date: Date())
            modelContext.insert(newTask)
            self.newTask = newTask
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
            }
        }
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        withAnimation {
            task.completed.toggle()
        }
    }
}
    
    #Preview {
        ContentView()
            .modelContainer(for: Task.self, inMemory: true)
    }
