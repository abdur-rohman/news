import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/helpers/constant.dart';
import 'package:news/helpers/dio_api.dart';
import 'package:news/models/info_model.dart';
import 'package:news/models/note_model.dart';
import 'package:news/widgets/text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedMenu = 0;
  late final Map<int, Widget> _menus = {
    0: const Text('Portal Berita'),
    1: const Text('Catatan'),
  };
  late final fullWidth = MediaQuery.of(context).size.width;
  late final fullHeight = MediaQuery.of(context).size.height;

  late final List<NewsModel> _news = [];
  late final List<NoteModel> _notes = [];

  late final _controller = TextEditingController();

  late bool _isManage = false;

  Future<List<NewsModel>> _fetchNews() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userName = sharedPreferences.getString(keyUsername) ?? '';

    final Response response = await DioApi.dio.get(
      'main/get_Information/$userName',
    );

    final InfoModel infoModel = InfoModel.fromJson(response.data);

    _news.clear();
    for (var item in infoModel.data.news) {
      _news.add(item);
    }

    return _news;
  }

  Widget _newsPage() {
    return FutureBuilder<List<NewsModel>>(
      future: _fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final news = _news[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.network(news.img),
                    ListTile(
                      title: Text(news.author),
                      subtitle: Text(news.tglTampil),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(news.isi),
                    )
                  ],
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<NoteModel>> _fetchNotes() async {
    final Response response = await DioApi.dio.get('account/note');
    final accountNoteModel = AccountNoteModel.fromJson(response.data);

    _notes.clear();
    for (var item in accountNoteModel.listNote) {
      _notes.add(item);
    }

    return _notes;
  }

  void _showNoteBottomSheet({NoteModel? note}) async {
    _controller.text = note != null ? note.note : '';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Batalkan'),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        note != null ? 'Ubah Catatan' : 'Tambah Catatan',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (note != null) {
                        await DioApi.dio.put(
                          'account/note/${note.id}',
                          data: {
                            'note': _controller.text,
                          },
                        );
                      } else {
                        await DioApi.dio.post(
                          'account/note',
                          data: {
                            'note': _controller.text,
                          },
                        );
                      }

                      _controller.clear();

                      Navigator.pop(context);
                    },
                    child: Text('Simpan'),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextInput(
                  controller: _controller,
                  hintText: 'Isi catatan',
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        );
      },
    );

    setState(() {});
  }

  Widget _notesPage() {
    return FutureBuilder<List<NoteModel>>(
      future: _fetchNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];

                    return ListTile(
                      leading: _isManage
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showNoteBottomSheet(note: note);
                              },
                            )
                          : null,
                      title: Text(note.note),
                      trailing: _isManage
                          ? IconButton(
                              onPressed: () async {
                                await DioApi.dio.delete(
                                  'account/note/${note.id}',
                                );

                                setState(() {});
                              },
                              icon: Icon(Icons.delete),
                            )
                          : null,
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text('Kelola Catatan'),
                        onPressed: () {
                          setState(() {
                            _isManage = !_isManage;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: const Text('Tambah Catatan'),
                        onPressed: () {
                          _showNoteBottomSheet();
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }

        return Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  List<Widget> _pages() => <Widget>[
        _newsPage(),
        _notesPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSlidingSegmentedControl<int>(
                children: _menus,
                groupValue: _selectedMenu,
                onValueChanged: (value) {
                  setState(() {
                    _selectedMenu = value ?? 0;
                  });
                },
              ),
            ),
            Expanded(child: _pages()[_selectedMenu]),
          ],
        ),
      ),
    );
  }
}
