import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note.dart';
import 'note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter note title',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter note content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pick a Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // المسافة الأفقية بين العناصر
              runSpacing: 8.0, // المسافة العمودية بين الأسطر
              children: Colors.primaries.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: _selectedColor == color
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isNotEmpty &&
                      _contentController.text.isNotEmpty) {
                    print("Saving note...");
                    final newNote = Note(
                      title: _titleController.text,
                      content: _contentController.text,
                      color: _selectedColor.value.toString(),
                    );

                    // عرض مؤشر تحميل
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      await noteProvider.addNoteToDatabase(newNote);
                      print("Note saved successfully");
                      Navigator.pop(context); // إغلاق مؤشر التحميل
                      Navigator.pop(context); // العودة للصفحة الرئيسية
                    } catch (e) {
                      Navigator.pop(context); // إغلاق مؤشر التحميل
                      print("Error saving note: $e");
                    }
                  } else {
                    print("Title or content is empty");
                  }
                },
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
