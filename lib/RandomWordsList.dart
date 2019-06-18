import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_launcher_icons/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @observable
  bool isLightTheme = true;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
//    final wordPair = WordPair.random();

    @action
    void _toggleTheme() {
      setState(() {
        if (widget.isLightTheme == true) {
          widget.isLightTheme = false;
          print('false');
        } else {
          widget.isLightTheme = true;
          print('true');
        }
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Observer(
        builder: (_) => RandomWords(
          onToggleTheme: _toggleTheme,
        ),
      ),
      theme: ThemeData(
        // Add the 3 lines from here...
        primaryColor: Colors.white,
        brightness: widget.isLightTheme ? Brightness.light : Brightness.dark,
        accentColor: Colors.yellow,
        accentIconTheme: IconThemeData(color: Colors.yellow),
        appBarTheme: AppBarTheme(
          color: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 100,
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white, fontSize: 18),
            headline: TextStyle(color: Colors.white),
            display2: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  RandomWords({
    Key key,
    this.onToggleTheme,
  }) : super(key: key);

  final Function() onToggleTheme;

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);
  final Set<WordPair> _saved = Set<WordPair>(); // Add this line.
  final List<WordPair> suggestions = <WordPair>[];

  void onReorder(int oldindex, int newindex) {
    if (newindex > oldindex) {
      newindex -= 1;
    }
    var x = _suggestions.removeAt(oldindex);
    _suggestions.insert(newindex, x);
  }

  Widget _buildSuggestions() {

    int index = 0; /*3*/
    if (index >= suggestions.length) {
      suggestions.addAll(generateWordPairs().take(50)); /*4*/
    }

    return
      ReorderableListView(
        children: suggestions.map((pair)=> _buildRow(index, pair)).toList(),
        onReorder: (oldIndex, newIndex) {
          onReorder(oldIndex, newIndex);
        },
        header: Text('this order'),
      );
//
//      ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: /*1*/ (context, i) {
//          if (i.isOdd) return Divider();
//          /*2*/
//
//          final index = i ~/ 2; /*3*/
//          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//          }
//          return _buildRow(index, _suggestions[index]);
//        });
  }

  Widget _buildRow(int value, WordPair pair) {
    final alreadySaved = _saved.contains(pair); // Add this li

    print(pair);

    return ListTile(
        key: ObjectKey(value),
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          // Add the lines from here...
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          // Add 9 lines from here...
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: Observer(
            builder: (_) => IconButton(
              icon: Text('${String.fromCharCodes(Runes('\u{1f596}'))}',
                  style: TextStyle(fontSize: 25)),
              onPressed: widget.onToggleTheme,
            ),
          ),
        ),
        title: Text('Inspiration Generator'),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
