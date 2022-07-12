import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/favourite/favourite_cubit.dart';
import 'package:podcast/screens/player.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    BlocProvider.of<FavouriteCubit>(context).fetchFavouriteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<FavouriteCubit, FavouriteState>(
            builder: (context, state) {
              if (state is FavouriteFetching) {
                loadingAlertBox();
                return Container();
              }
              if (state is FavouriteFetched) {
                EasyLoading.dismiss();
                return Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: ListView.builder(
                    itemCount: state.podcastdata.length,
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PodcastPlayer(
                                            title:
                                                '${state.podcastdata[index].title}',
                                            artist:
                                                '${state.podcastdata[index].artist}',
                                            category:
                                                '${state.podcastdata[index].category}',
                                            image:
                                                '${state.podcastdata[index].image}',
                                            audio:
                                                '${state.podcastdata[index].audio}',
                                          ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      maxRadius: 20,
                                      backgroundImage: NetworkImage(
                                          '${state.podcastdata[index].image}'),
                                    ),
                                    title: Text(
                                        '${state.podcastdata[index].title}'),
                                    trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          child: ListTile(
                                            leading: Icon(FontAwesomeIcons
                                                .heartCircleCheck),
                                            title: Text('Liked'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
    EasyLoading.show(status: 'Fetching Your Favourite Podcast...');
  }
}
