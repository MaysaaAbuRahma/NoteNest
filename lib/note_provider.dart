import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';

class NoteProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  List<Note> _notes = [];

  bool get isDarkMode => _isDarkMode;
  List<Note> get notes => _notes;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // جلب الملاحظات من قاعدة البيانات
  Future<void> fetchNotes() async {
    final stopwatch = Stopwatch()..start(); // لتسجيل الوقت
    final notes = await DatabaseHelper.instance.getNotes();
    _notes = notes;
    notifyListeners();
    print("Fetch Notes completed in: ${stopwatch.elapsedMilliseconds} ms");
  }

  // إضافة ملاحظة جديدة إلى الواجهة
  void addNoteToUI(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  // حفظ الملاحظة في قاعدة البيانات
  Future<void> addNoteToDatabase(Note note) async {
    await DatabaseHelper.instance.insert(note);
  }

  // حذف ملاحظة
// حذف ملاحظة
  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id); // حذف الملاحظة من قاعدة البيانات
    _notes.removeWhere((note) => note.id == id); // حذف الملاحظة من الواجهة
    notifyListeners();
  }

  Future<void> updateNoteInDatabase(Note updatedNote) async {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }
}
