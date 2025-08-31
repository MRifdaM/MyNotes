import 'package:flutter/material.dart';
import '../models/note.dart';
import '../helpers/database_helper.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final note = Note(
        title: _title,
        content: _content,
        date:
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      );

      await DatabaseHelper.instance.insertNote(note);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Tambah Catatan" : "Edit Catatan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: "Judul"),
                validator: (val) => val!.isEmpty ? "Judul tidak boleh kosong" : null,
                onSaved: (val) => _title = val!,
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: "Isi"),
                validator: (val) => val!.isEmpty ? "Isi tidak boleh kosong" : null,
                onSaved: (val) => _content = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
