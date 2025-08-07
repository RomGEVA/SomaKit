import SwiftUI

struct Note: Codable, Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var date: Date
}

struct NotesView: View {
    @Binding var currentScreen: Screen
    @State private var notes: [Note] = []
    @State private var showingAddNote = false
    @State private var editingNote: Note?
    @State private var animateList = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentScreen = .home
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Reflections")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingAddNote = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                .padding(.bottom, 30)
                
                // Notes list
                if notes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No notes")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("Click + to create your first note")
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: animateList ? 0 : 50)
                    .opacity(animateList ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8), value: animateList)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                                NoteCardView(note: note) {
                                    editingNote = note
                                } onDelete: {
                                    deleteNote(note)
                                }
                                .offset(x: animateList ? 0 : 300)
                                .opacity(animateList ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: animateList)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            loadNotes()
            animateList = true
        }
        .sheet(isPresented: $showingAddNote) {
            NoteEditView(note: nil) { title, content in
                addNote(title: title, content: content)
            }
        }
        .sheet(item: $editingNote) { note in
            NoteEditView(note: note) { title, content in
                updateNote(note, title: title, content: content)
            }
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes.sorted { $0.date > $1.date }
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    private func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content, date: Date())
        notes.insert(newNote, at: 0)
        saveNotes()
    }
    
    private func updateNote(_ note: Note, title: String, content: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = Note(title: title, content: content, date: note.date)
            saveNotes()
        }
    }
    
    private func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
}

struct NoteCardView: View {
    let note: Note
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(note.content)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    
                    Text(note.date, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                Spacer()
                
                Menu {
                    Button("Edit") {
                        onEdit()
                    }
                    
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                onEdit()
            }
        }
    }
}

struct NoteEditView: View {
    let note: Note?
    let onSave: (String, String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(note == nil ? "New note" : "Edit")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSave(title, content)
                            dismiss()
                        }
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Headline")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Enter a title", text: $title)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        CustomTextEditor(text: $content)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .frame(minHeight: 200)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .onAppear {
            if let note = note {
                title = note.title
                content = note.content
            }
        }
    }
}

#Preview {
    NotesView(currentScreen: .constant(.notes))
} 
