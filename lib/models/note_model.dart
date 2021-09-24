class AccountNoteModel {
  final List<NoteModel> listNote;

  AccountNoteModel({required this.listNote});

  factory AccountNoteModel.fromJson(Map<String, dynamic> json) {
    final notes = <NoteModel>[];

    for (var item in (json['list_note'] ?? [])) {
      notes.add(NoteModel.fromJson(item ?? {}));
    }

    return AccountNoteModel(listNote: notes);
  }
}

class NoteModel {
  final String id, note, updatedAt, createdAt;

  NoteModel({
    required this.id,
    required this.note,
    required this.updatedAt,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      note: json['note'] ?? '',
      updatedAt: json['udt'] ?? '',
      createdAt: json['cdt'] ?? '',
    );
  }
}
