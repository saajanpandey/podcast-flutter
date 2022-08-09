import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:podcast/cubit/category/category_cubit.dart';
import 'package:podcast/main.dart';
import 'package:podcast/screens/CategoryPodcast.dart';
import 'package:podcast/screens/player.dart';
import 'package:podcast/services/StorageService.dart';
import 'package:podcast/services/ApiService.dart';

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
  int? id;
  String? catId;
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
                  onTap: () async {
                    id = filteredNames[index]['id'];
                    await getIt<ApiService>().plays(id);
                    // ignore: use_build_context_synchronously
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
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<CategoryCubit>(context).categoryData();
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
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryFetching) {
              loadingAlertBox();
              return Container();
            } else if (state is CategorySuccess) {
              EasyLoading.dismiss();
              return Column(
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
                        setState(
                          () {
                            _filter.clear();
                          },
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 1.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20),
                    itemCount: state.category.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPodcast(
                                id: state.category[index].id,
                                title: state.category[index].title,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${state.category[index].image}'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${state.category[index].title}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'All Podcast',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildList(),
                  )
                ],
              );
            } else {
              EasyLoading.dismiss();
              return Container(
                child: Text('asdasd'),
              );
            }
          },
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Fetching Categories...');
  }

  errorAlertBox(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Failed'),
        content: Text('$message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
// Column(
//   children:[]
// )
  // Padding(
  //               padding: const EdgeInsets.only(right: 10),
  //               child: AnimSearchBar(
  //                   helpText: 'Search Podcast...',
  //                   closeSearchOnSuffixTap: true,
  //                   color: Colors.grey[400],
  //                   rtl: true,
  //                   width: 400,
  //                   textController: _filter,
  //                   onSuffixTap: () {
  //                     setState(() {
  //                       _filter.clear();
  //                     });
  //                   }),
  //             ),
}
