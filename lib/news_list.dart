import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'news.dart';
import 'dart:async';

class NewsList extends StatefulWidget {
  const NewsList();

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<News> _newsList;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTodoList(),
        floatingActionButton: FloatingActionButton(
            onPressed: _showAddToDoPage
            , child: Icon(Icons.add)),
    );
  }

  @override
  void initState() {
    super.initState();
    _showAddToDoPage();
  }

  void _showAddToDoPage() {
    News news = News();
//    setState(() {
//      _newsList.add(news);
//    });
    _searchRepositories().then((result) {
      setState(() {
        _newsList = result;
      });
    });
  }

  Widget _buildTodoList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i >= _newsList.length) {
            return null;
          } else {
            return _buildRow(_newsList[i]);
          }
        },
    itemCount: _newsList.length,);
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch';
    }
  }

  void _pushSaved(String url) {
    if (Platform.isIOS) {
      _launchUrl(url);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<News>> _searchRepositories() async {
    final response = await http.get('');
    if (response.statusCode == 200) {
      List<News> list = [];
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['articles']) {
        News news = News.fromJson(item);
        if (news.urlToImageRawValue == null) {
          news.urlToImageRawValue = "https://1.bp.blogspot.com/-D2I7Z7-HLGU/Xlyf7OYUi8I/AAAAAAABXq4/jZ0035aDGiE5dP3WiYhlSqhhMgGy8p7zACNcBGAsYHQ/s400/no_image_square.jpg";
        }
        list.add(news);
      }
      return list;
    } else {
      throw Exception('Fail to search repository');
    }
  }

  Widget _buildRow(News item) {
    return
      Container(
          height: 150.0,
          child: Card(
            child: new InkWell(
              onTap: () {
                _pushSaved(item.urlRawValue);
              },
              child: ListTile(
                leading: Container(
                    height : 150,
                    width : 100,
                    child : Image.network(item.urlToImageRawValue)),
                title: Container(
                    height: 100,
                    child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0),)),
                subtitle: Text((DateFormat('MM/dd/yyyy HH:mm')).format(item.publishedAt).toString(), textAlign: TextAlign.center,),
              ),
            ),
          ),
      );
  }
}