import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/addFavourite/add_favourite_cubit.dart';
import 'package:podcast/cubit/podcast/podcast_cubit.dart';
import 'package:podcast/cubit/removeFavourite/remove_favourite_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? id;
  String? podcastId;
  @override
  void initState() {
    BlocProvider.of<PodcastCubit>(context).fetchPodcastData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: MultiBlocListener(
            listeners: [
              BlocListener<RemoveFavouriteCubit, RemoveFavouriteState>(
                listener: (context, state) {
                  if (state is RemoveFavouriteFetched) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationWidget(),
                        ),
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
              ),
              BlocListener<AddFavouriteCubit, AddFavouriteState>(
                listener: (context, state) {
                  if (state is AddFavouriteFetched) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationWidget(),
                        ),
                        (route) => false);
                    final snackBar = SnackBar(
                      content: const Text('Podcast Marked as favourite.'),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ],
            child: BlocBuilder<PodcastCubit, PodcastState>(
              builder: (context, state) {
                // if (state is PodcastFetching) {
                //   loadingAlertBox();
                // }
                if (state is PodcastFetched) {
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
                                          PopupMenuItem(
                                            child:
                                                '${state.podcastdata[index].favourite}' ==
                                                        'true'
                                                    ? ListTile(
                                                        leading: const Icon(
                                                            FontAwesomeIcons
                                                                .heartCircleCheck),
                                                        title:
                                                            const Text('Liked'),
                                                        onTap: () {
                                                          id =
                                                              '${state.podcastdata[index].id}';
                                                          BlocProvider.of<
                                                                      RemoveFavouriteCubit>(
                                                                  context)
                                                              .remove(id);
                                                        },
                                                      )
                                                    : ListTile(
                                                        leading: const Icon(
                                                            FontAwesomeIcons
                                                                .heart),
                                                        title:
                                                            const Text('Like'),
                                                        onTap: () {
                                                          podcastId =
                                                              '${state.podcastdata[index].id}';
                                                          BlocProvider.of<
                                                                      AddFavouriteCubit>(
                                                                  context)
                                                              .postFavourite(
                                                                  podcastId);
                                                        },
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
                } else if (state is PodcastFetching) {
                  loadingAlertBox();
                  return Container();
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
    EasyLoading.show(status: 'Fetching Podcast...');
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
}
