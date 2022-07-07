import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/cubit/podcast/podcast_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<PodcastCubit>(context).fetchPodcastData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<PodcastCubit, PodcastState>(
            builder: (context, state) {
              if (state is PodcastFetching) {
                loadingAlertBox();
              }
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
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: ListTile(
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
                                              leading:
                                                  Icon(FontAwesomeIcons.heart),
                                              title: Text('Like'),
                                            ),
                                          ),
                                        ],
                                      ),
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
                return Container(
                  child: Text('Hello'),
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
