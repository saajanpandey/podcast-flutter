import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/categoryPodcast/category_podcast_cubit.dart';
import 'package:podcast/cubit/removeFavourite/remove_favourite_cubit.dart';
import 'package:podcast/main.dart';
import 'package:podcast/screens/player.dart';
import 'package:podcast/services/ApiService.dart';

class CategoryPodcast extends StatefulWidget {
  final int? id;
  final String? title;
  const CategoryPodcast({Key? key, this.id, this.title}) : super(key: key);

  @override
  State<CategoryPodcast> createState() => _CategoryPodcastState();
}

class _CategoryPodcastState extends State<CategoryPodcast> {
  @override
  void initState() {
    BlocProvider.of<CategoryPodcastCubit>(context)
        .fetchFavouriteData(widget.id);
    super.initState();
  }

  String? id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<CategoryPodcastCubit, CategoryPodcastState>(
            builder: (context, state) {
              if (state is CategoryPodcastFetching) {
                loadingAlertBox();
                return Container();
              } else if (state is CategoryPodcastFetched) {
                EasyLoading.dismiss();
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                        child: Text(
                          "${widget.title}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.82,
                      child: ListView.builder(
                        itemCount: state.categoryPodcast.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () async {
                                          id =
                                              '${state.categoryPodcast[index].id}';
                                          await getIt<ApiService>().plays(id);
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PodcastPlayer(
                                                title:
                                                    '${state.categoryPodcast[index].title}',
                                                artist:
                                                    '${state.categoryPodcast[index].artist}',
                                                image:
                                                    '${state.categoryPodcast[index].image}',
                                                audio:
                                                    '${state.categoryPodcast[index].audio}',
                                              ),
                                            ),
                                          );
                                        },
                                        leading: CircleAvatar(
                                          maxRadius: 20,
                                          backgroundImage: NetworkImage(
                                              '${state.categoryPodcast[index].image}'),
                                        ),
                                        title: Text(
                                            '${state.categoryPodcast[index].title}'),
                                        subtitle: Text(
                                            '${state.categoryPodcast[index].artist}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is CategoryPodcastNull) {
                EasyLoading.dismiss();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250),
                        child: Text(
                          "No Podcast Found!",
                          style: TextStyle(color: Colors.purple, fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                EasyLoading.dismiss();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250),
                        child: Text(
                          "Something Went Wrong!",
                          style: TextStyle(color: Colors.purple, fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Fetching Podcast...');
  }
}
