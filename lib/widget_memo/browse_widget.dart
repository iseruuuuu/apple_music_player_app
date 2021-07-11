import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/home.dart';
import '../musicservice.dart';
import 'album_widget.dart';
import '../widget/carousel_album.dart';
import '../widget/carousel_song_widget.dart';

//TODO ホーム画面

class BrowseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseWidgetState();
  }
}

class _BrowseWidgetState extends State<BrowseWidget> {
  final musicStore = AppleMusicStore.instance;
  Future<Home> _home;

  @override
  void initState() {
    super.initState();
    _home = musicStore.fetchBrowseHome();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sapotify'),
      ),
      child: FutureBuilder<Home>(
        future: _home,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final albumChart = snapshot.data.chart.albumChart;
            final List<Widget> list = [];
            if (albumChart != null) {
              list.add(
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
              );
              list.add(
                //写真が２つ並んでいるやつ！
                CarouselAlbumWidget(
                  title: albumChart.name,
                  albums: albumChart.albums,
                ),
              );
            }
            final songChart = snapshot.data.chart.songChart;
            if (songChart != null) {
              list.add(
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
              );
              //TODO CarouselSongWidget
              list.add(
                CarouselSongWidget(
                  title: songChart.name,
                  songs: songChart.songs,
                ),
              );
            }
            snapshot.data.albums.forEach((f) {
              list.add(
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
              );
              list.add(
                CarouselSongWidget(
                  title: f.name,
                  songs: f.songs,
                  cta: 'carousel_song_widget',
                  onCtaTapped: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(
                      CupertinoPageRoute(
                        builder: (context) => AlbumWidget(
                          albumId: f.id,
                          albumName: f.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            });
            return ListView(
              children: list,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}