import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_nest_app/note_provider.dart';
import 'package:provider/provider.dart';
import 'note_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // إضافة المكتبة
//import 'package:flutter/foundation.dart';
import 'view_note_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: Consumer<NoteProvider>(
        builder: (context, noteProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: noteProvider.isDarkMode
                ? ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: Colors.black,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                  )
                : ThemeData.light().copyWith(
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
            home: NoteListScreen(),
          );
        },
      ),
    );
  }
}
