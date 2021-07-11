import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:async';
import '../musicservice.dart';
import '../model/song.dart';


import 'model/artist.dart';
import 'model/home.dart';
import 'model/album.dart';


class PlayWidget extends StatefulWidget {
  //const PlayWidget({Key key, this.song}) : super(key: key);
  //final Song song;

  @override
  State<StatefulWidget> createState() {
    return _PlayWidgetState();
  }
}


//TODO スライダーを動かせるようにしたい。
//TODO 音楽が終わったら、次の曲を再生したい。
//TODO NavigatorBarの調整
//TODO　再生画面の位置


//TODO APIを使って取得したい。

class _PlayWidgetState extends State<PlayWidget> {

  bool _isPlaying = false;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;
  String _startText = '00:00';
  String _endText = '00:00';
  double slider_current_position = 0.0;
  double max_duration = 1.0;
  int musicCount = 0;
  String musicNames = '';
  String musicURL = '';
  String musicArtist = '';

  String Name = '';
  String Song = '';
  String URL = '';


  //TODO アルバムの取得
  final musicStore = AppleMusicStore.instance;
  Future<Home> _home;

  //曲の取得
  Future<Album> _album;
  AppleMusicStore _musicStore = AppleMusicStore.instance;



  // _album = _musicStore.fetchAlbumById(widget.albumId);


  @override
  void initState() {
    super.initState();
    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();

    musicName();

    _home = musicStore.fetchBrowseHome();
    //_album = _musicStore.fetchAlbumById(widget.albumId);
  }
  void musicName() {
    if (musicCount == 0) {
      musicNames = 'Epiloque';
      musicURL = 'https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/4b/ba/5b/4bba5b81-c56e-1513-4326-e24daf4a7bff/195497666737.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 1) {
      musicNames = 'アンコール';
      musicURL = 'https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/92/1e/53/921e53b8-200d-04c7-3936-a65e11ad81ec/196006915353.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 2) {
      musicNames = 'ハルジオン';
      musicURL = 'https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/d3/23/ac/d323ac61-2d0b-2d15-6907-fdf994be8ba1/195081470399.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 3) {
      musicNames = 'もう少しだけ';
      musicURL = 'https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/f8/03/83/f803837d-7056-6983-f1be-b0f03ff3ad6d/196006562731.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 4) {
      musicNames = 'あの夢をなぞって';
      musicURL = 'https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/e2/b2/7b/e2b27bda-dfcd-323d-da30-894f646f3ed1/194491839147.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 5) {
      musicNames = 'たぶん';
      musicURL = 'https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/bf/1c/3b/bf1c3bdd-a128-2843-776a-35bf3c879d98/195081850498.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 6) {
      musicNames = '群青';
      musicURL = 'https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/ae/7e/4a/ae7e4a28-fd46-9617-1066-fcbd124303d6/195497105656.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 7) {
      musicNames = 'ハルカ';
      musicURL = 'https://is4-ssl.mzstatic.com/image/thumb/Music125/v4/6f/92/2d/6f922d2d-735d-59bd-00a0-d845371bb99c/195497666263.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 8) {
      musicNames = '夜にかける';
      musicURL = 'https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/fe/58/79/fe58795c-1628-230a-9ffe-300c04b6627c/194491717186.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 9) {
      musicNames = 'Prologue';
      musicURL = 'https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/4b/ba/5b/4bba5b81-c56e-1513-4326-e24daf4a7bff/195497666737.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
    if (musicCount == 10) {
      musicNames = '怪物';
      musicURL = 'https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/b8/e9/56/b8e956c2-0f3c-9070-af1e-2bb01cc76bc5/195497732630.jpg/512x512bb.jpeg';
      musicArtist = 'YOASOBI';
    }
  }
  void startPlay() async {
    //TODO 共通しているもの
    String url = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114';
    String uri = '';
    if (musicCount == 0) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/28/e9/55/28e955d4-4c12-ddf9-1303-130f09f66313/mzaf_14546878453801592626.plus.aac.p.m4a';
    }
    if(musicCount == 1){
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/0e/63/40/0e634086-8f4f-44e4-4a62-6a24248ea772/mzaf_4694059619089010795.plus.aac.p.m4a';
    }
    if (musicCount == 2) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/cb/66/72/cb66722e-e947-ed3d-54e1-535c365b4b1f/mzaf_9441649821997988077.plus.aac.p.m4a';
    }
    if (musicCount == 3) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/2a/29/9e/2a299ed3-15af-7442-af89-076011ae06ad/mzaf_14108541686281494394.plus.aac.p.m4a';
    }
    if (musicCount == 4) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/94/75/fe/9475fee2-93ae-609c-98de-0729fbe59abd/mzaf_12988314150807636579.plus.aac.p.m4a';
    }
    if (musicCount == 5) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/06/39/86/063986c1-398a-8c11-c224-63f081a38cc4/mzaf_1933875615341974144.plus.aac.p.m4a';
    }
    if (musicCount == 6) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/d0/a9/45/d0a9457c-d648-2630-6045-b14e198d6ce6/mzaf_13953057179499048390.plus.aac.p.m4a';
    }
    if (musicCount == 7) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/93/09/cb/9309cb90-ed66-152d-2f8e-c0e742362013/mzaf_13428102244061067709.plus.aac.p.m4a';
    }
    if (musicCount == 8) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/49/34/d5/4934d5ff-1b76-d374-1f55-d2ecb03779d7/mzaf_17140922054880000870.plus.aac.p.m4a';
    }
    if (musicCount == 9) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/41/6c/83/416c83fe-a79a-9e6a-c7f7-2c78c1224e7e/mzaf_14559737867725135033.plus.aac.p.m4a';
    }
    if (musicCount == 10) {
      uri = 'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/63/7a/ce/637ace09-4a76-1835-8faa-00f7564e30a4/mzaf_14023107386124344876.plus.aac.p.m4a';
    }
    //uri = '';



    String Path = await flutterSound.startPlayer(uri);
    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) async {
        if (e != null) {
          //TODO スライダーの設定
          slider_current_position = e.currentPosition;
          max_duration = e.duration;
          final remaining = e.duration - e.currentPosition;
          DateTime date = DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(), isUtc: true);
          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(remaining.toInt(), isUtc: true);
          String startText = DateFormat('mm:ss', 'en_GB').format(date);
          String endText = DateFormat('mm:ss', 'en_GB').format(endDate);
          if (mounted) {
            setState(() {
              _startText = startText;
              _endText = endText;
              slider_current_position = slider_current_position;
              max_duration = max_duration;
            });
          }
        } else {
          slider_current_position = 0;
          if (_playerSubscription != null) {
            _playerSubscription.cancel();
            _playerSubscription = null;
          }
          setState(() {
            _isPlaying = false;
            _startText = '00:00';
            _endText = '00:00';
            //TODO 次の曲を再生する。
            if(musicCount == 10) {
              musicCount = 0;
            }else {
              musicCount += 1;
              musicName();
              _isPlaying == true;
              // String Path = await flutterSound.startPlayer(uri);
            }
          });
        }
      });
    } catch (err) {
      print('error: $err');
      setState(() {
        _isPlaying = false;
      });
    }
  }
  void changeMusic () {

  }
  void startPlayer(String uri) async {
    //String path = await flutterSound.startPlayer(uri);
    String path = await flutterSound.startPlayer('https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/cb/66/72/cb66722e-e947-ed3d-54e1-535c365b4b1f/mzaf_9441649821997988077.plus.aac.p.m4a');
    // String path = await flutterSound.startPlayer('https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/0e/63/40/0e634086-8f4f-44e4-4a62-6a24248ea772/mzaf_4694059619089010795.plus.aac.p.m4a');
    //  await flutterSound.setVolume(1.0);
    // print('startPlayeddr: $path');
    // print('ssrsra : $uri');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) async {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;
          final remaining = e.duration - e.currentPosition;
          DateTime date = DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(), isUtc: true);
          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(remaining.toInt(), isUtc: true);
          String startText = DateFormat('mm:ss', 'en_GB').format(date);
          String endText = DateFormat('mm:ss', 'en_GB').format(endDate);
          if (mounted) {
            setState(() {
              _startText = startText;
              _endText = endText;
              slider_current_position = slider_current_position;
              max_duration = max_duration;
            });
          }
        } else {
          slider_current_position = 0;
          if (_playerSubscription != null) {
            _playerSubscription.cancel();
            _playerSubscription = null;
          }
          setState(() {
            _isPlaying = false;
            _startText = '00:00';
            _endText = '00:00';
          });
        }
      });
    } catch (err) {
      print('error: $err');
      setState(() {
        _isPlaying = false;
      });
    }
  }
  _pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
    setState(() {
      _isPlaying = false;
    });
  }
  _resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
    setState(() {
      _isPlaying = true;
    });
  }
  _seekToPlayer(int milliSecs) async {
    int secs = Platform.isIOS ? milliSecs / 1000 : milliSecs;
    if (_playerSubscription == null) {
      return;
    }
    String result = await flutterSound.seekToPlayer(secs);
    print('seekToPlayer: $result');
  }
  @override
  void dispose() async {
    super.dispose();
    await flutterSound.stopPlayer();
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: FutureBuilder<Home>(
        future: _home,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final album = snapshot.data;
            for (var f in snapshot.data.albums) {
              //album.songs.forEach((s) {

              Name = f.artistName;
              Song = f.artistId;
              URL = f.artworkRawUrl;

              //artistId 463996386
              //href /v1/catalog/jp/albums/1340242365
              //name Oxygen
              //artworkRawUrl https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/d3/d3/84/d3d3841f-689a-896f-8a64-d108fa80fdb8/8994945002514.jpg

              //https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/d3/d3/84/d3d3841f-689a-896f-8a64-d108fa80fdb8/8994945002514.jpg
              //https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/d3/d3/84/d3d3841f-689a-896f-8a64-d108fa80fdb8/8994945002514.jpg/512x512bb.jpeg
            }
          } else{
            Name = '';
            Song = '';
          }
          return Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2.2,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        // has the effect of softening the shadow
                        spreadRadius: 1.0,
                        // has the effect of extending the shadow
                        offset: Offset(0.5, 0.5,),
                      ),
                    ]),
                    margin: const EdgeInsets.only(
                        top: 50, right: 16.0, left: 16.0),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          //widget.song.artworkUrl(512),
                          musicURL,
                          //URL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: CupertinoSlider(
                      value: slider_current_position,
                      min: 0.0,
                      max: max_duration,
                      onChangeEnd: (x) {},
                      onChangeStart: (x) {},
                      onChanged: (double value) async {
                        //await _seekToPlayer(value.toInt());
                      },
                      divisions: max_duration.toInt(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _startText,
                          textAlign: TextAlign.start,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        ),
                        Text(
                          _endText,
                          textAlign: TextAlign.end,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 32.0, right: 32.0, bottom: 6.0),
                    child: Text(
                      //widget.song.name,
                      //'ヤッホー(⌒▽⌒) + $musicCount',
                      musicNames,
                      //style: Theme.of(context).textTheme.subhead,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 32.0, right: 32.0, bottom: 10.0),
                    child: Text(
                      //"${widget.song.artistName} - ${widget.song.albumName}",
                      // 'ヤッホー(⌒▽⌒) + $musicCount',
                      // musicNames,
                      //musicArtist,
                      Name,
                      textAlign: TextAlign.center,
                      //style: Theme.of(context).textTheme.subhead,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              //TODO 再生ボタンなどのやつ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: ClipOval(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //TODO 画像を変える（widget.song.artworkUrl(512),）
                            //TODO 曲を変える（widget.song.previewUrl）
                            //TODO 曲名を変える（widget.song.name,）
                            //TODO アーティスト名を変える（${widget.song.artistName} - ${widget.song.albumName}）
                            // musicCount -= 1;

                            flutterSound.stopPlayer();
                            if (musicCount == 0) {

                            } else {
                              musicCount -= 1;
                              musicName();
                            }
                          });
                        }, child: const Icon(
                        Icons.skip_previous,
                        size: 50,
                        color: Colors.white,),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: ClipOval(
                      child: ElevatedButton(
                        onPressed: () {
                          print(Name);
                          print(Song);
                          if (_isPlaying) {
                            _pausePlayer();
                          } else {
                            if (_playerSubscription == null) {
                              setState(() {
                                _isPlaying = true;
                              });
                              Timer(Duration(milliseconds: 200), () {
                                // startPlayer(widget.song.previewUrl);
                                //startPlayer('');
                                startPlay();
                              }
                              );
                            } else {
                              _resumePlayer();
                            }
                          }
                        },
                        // padding: EdgeInsets.all(8.0),
                        // child: Image(
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: ClipOval(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //TODO 画像を変える（widget.song.artworkUrl(512),）
                            //TODO 曲を変える（widget.song.previewUrl）
                            //TODO 曲名を変える（widget.song.name,）
                            //TODO アーティスト名を変える（${widget.song.artistName} - ${widget.song.albumName}）

                            if (musicCount == 10) {
                              musicCount = 0;
                            } else {
                              musicCount += 1;
                              musicName();
                            }
                            //音を止める
                            flutterSound.stopPlayer();
                          });
                        },
                        child: const Icon(
                          Icons.skip_next,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}