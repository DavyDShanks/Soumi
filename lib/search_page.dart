import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  KeyboardListener? _keyboardListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60,
        backgroundColor: Colors.black,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.mic, color: Colors.white),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) => setState(() {
                    if (value.isNotEmpty) {
                      _searchHistory.add(value);
                      _searchController.clear();
                    }
                  }),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (_searchController.text.isNotEmpty) {
                            _searchHistory.add(_searchController.text);
                            _searchController.clear();
                          }
                        });
                      },
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                    label: Text("Search"),
                    labelStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.extension, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _searchHistory[_searchHistory.length - index - 1],
              style: TextStyle(color: Colors.white),
            ),
            trailing: IconButton(onPressed: () {
              setState(() {
                _searchHistory.removeAt(index);
              });
            }, icon: Icon(Icons.delete, color: Colors.white54),),
            leading: Icon(Icons.history, color: Colors.white54),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _searchHistory.clear();
          });
        },
        child: Icon(
          Icons.clear,
          color: Colors.black),
      ),
    );
  }
}
