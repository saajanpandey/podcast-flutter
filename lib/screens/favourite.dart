import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/favourite/favourite_cubit.dart';
import 'package:podcast/cubit/removeFavourite/remove_favourite_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/player.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  String? id;
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
          child: BlocListener<RemoveFavouriteCubit, RemoveFavouriteState>(
            listener: (context, state) {
              if (state is RemoveFavouriteFetched) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationWidget()),
                    (route) => false);
                final snackBar = SnackBar(
                  content: const Text('Podcast Removed as Favourite.'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: BlocBuilder<FavouriteCubit, FavouriteState>(
              builder: (context, state) {
                if (state is FavouriteFetching) {
                  loadingAlertBox();
                  return Container();
                }
                if (state is FavouriteFetched) {
                  EasyLoading.dismiss();
                  return Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Text(
                            "Your Favourites",
                            style: TextStyle(
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
                                                builder: (context) =>
                                                    PodcastPlayer(
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
                                          subtitle: Text(
                                              '${state.podcastdata[index].artist}'),
                                          trailing: PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                child: const ListTile(
                                                  leading: Icon(FontAwesomeIcons
                                                      .heartCircleCheck),
                                                  title: Text('Liked'),
                                                ),
                                                onTap: () {
                                                  id =
                                                      '${state.podcastdata[index].id}';
                                                  BlocProvider.of<
                                                              RemoveFavouriteCubit>(
                                                          context)
                                                      .remove(id);
                                                },
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
                      ),
                    ],
                  );
                } else if (state is FavouriteNull) {
                  EasyLoading.dismiss();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 250),
                          child: Text(
                            "No Favourites",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 30),
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
                            style:
                                TextStyle(color: Colors.purple, fontSize: 30),
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
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Fetching Your Favourite Podcast...');
  }
}
