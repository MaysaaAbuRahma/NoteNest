import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'note_provider.dart';
import 'view_note_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  void initState() {
    super.initState();
    // استدعاء fetchNotes مرة واحدة عند بناء الشاشة
    Future.microtask(() {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      noteProvider.fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              noteProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: noteProvider.notes.isEmpty
          ? const Center(
              child: Text(
                'No Notes Yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: noteProvider.notes.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Color(int.parse(note.color)),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        // تأكيد الحذف
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text(
                                'Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          // حذف الملاحظة
                          noteProvider.deleteNote(note.id!);
                        }
                      },
                    ),
                    onTap: () {
                      // عرض تفاصيل الملاحظة
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNoteScreen(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
          // تحديث قائمة الملاحظات بعد إضافة ملاحظة جديدة
          noteProvider.fetchNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
