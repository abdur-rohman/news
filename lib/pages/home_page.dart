import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/helpers/constant.dart';
import 'package:news/helpers/dio_api.dart';
import 'package:news/models/info_model.dart';
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
  late bool _isLoading = false;
  late final List<NewsModel> _news = [];

  void _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
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
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }

    setState(() {
      _isLoading = false;
    });
  }

  late final _pages = <Widget>[
    _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final news = _news[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.network(news.img),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text(news.author),
                      subtitle: Text(news.tglTampil),
                    ),
                    SizedBox(height: 8),
                    Text(news.isi)
                  ],
                ),
              );
            },
          ),
    Center(
      child: Text('Aplikasi Catatan'),
    )
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(child: _pages[_selectedMenu]),
          ],
        ),
      ),
    );
  }
}
