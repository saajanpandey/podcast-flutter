import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:podcast/screens/player.dart';
import 'package:podcast/services/StorageService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  final TextEditingController _filter = TextEditingController();
  final dio = Dio(); // for http requests
  String _searchText = "";
  List names = []; // names we get from API
  List filteredNames = []; // names filtered by search text
  // Icon _searchIcon = Icon(Icons.search);
  // Widget _appBarTitle = Text('Search Example');

  void _getNames() async {
    var token = await StorageService().getLoginToken();
    final response = await dio.get(
      'http://10.0.2.2:8000/api/v1/podcast-list',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    List tempList = [];
    for (int i = 0; i < response.data['data'].length; i++) {
      tempList.add(response.data['data'][i]);
    }
    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['title']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: names.isEmpty ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: Colors.grey[400],
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PodcastPlayer(
                          title: filteredNames[index]['title'],
                          artist: filteredNames[index]['artist'],
                          image: filteredNames[index]['image'],
                          audio: filteredNames[index]['audio'],
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    maxRadius: 20,
                    backgroundImage:
                        NetworkImage(filteredNames[index]['image']),
                  ),
                  subtitle: Text(filteredNames[index]['artist']),
                  title: Text(filteredNames[index]['title']),
                ),
              ],
            ),
          ),
        );
        // return ListTile(
        //   title: Text(filteredNames[index]['title']),
        // );
      },
    );
  }

  @override
  void initState() {
    _getNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Search",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AnimSearchBar(
                    helpText: 'Search Podcast...',
                    closeSearchOnSuffixTap: true,
                    color: Colors.grey[400],
                    rtl: true,
                    width: 400,
                    textController: _filter,
                    onSuffixTap: () {
                      setState(() {
                        _filter.clear();
                      });
                    }),
              ),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }
}
