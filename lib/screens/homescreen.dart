import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:musicplayer/screens/music_info_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const String ApiKey = "abcc70b147b47acd7e686e904a144b77";
const String url =
    "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$ApiKey";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List songs = [];
  bool isloaded = false;

  StreamController<bool>? MyStream = StreamController();

  @override
  initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      MyStream?.sink.add(connected);
    });

    getData();
  }

  void getData() async {
    //print("start");

    var uri = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$ApiKey");
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      String data = response.body;
      // var time = jsonDecode(data)['message']['body']['track_list'][0]['track']
      //     ['track_id'];
      var time = jsonDecode(data)['message']['body']['track_list'];
      //print(time);
      // print("length : ${songs.length}");
      setState(() {
        songs = time;
        isloaded = true;
      });
      //print("end");
      //message.body.track_list[0].track.track_id
      // print(response.body);
    } else {
      songs = [];
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<bool>(
        stream: MyStream?.stream,
        builder: (context, snapshot) {
          print(snapshot.data);
          return (snapshot.data == true)
              ? Scaffold(
                  backgroundColor: Color(0xFFF6BAA5),
                  appBar: AppBar(
                    backgroundColor: Color(0xFFF6BAA5),
                    elevation: 2,
                    title: Text(
                      "Trending",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    centerTitle: true,
                  ),
                  body: (isloaded == false)
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                        ))
                      : Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.deepOrangeAccent.withOpacity(.8),
                                      BlendMode.dstATop),
                                  image: AssetImage('images/bg.jpg'),
                                  fit: BoxFit.cover)),
                          child: ListView.builder(
                              itemCount: songs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MusicInfoPage(
                                          songs[index]['track']['track_id'],
                                        );
                                      }));
                                    },
                                    child: Container(
                                      height: size.height * 0.1,
                                      width: size.width * 0.75,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ), //Border.all
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3,
                                              color: Color(0x64E0E3E7)
                                                  .withOpacity(.1),
                                              offset: Offset(0, 2),
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              (songs[index]['track']
                                                      ['track_name'])
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Center(
                                            child: Text(
                                              (songs[index]['track']
                                                      ['album_name'])
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(.6),
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                )
              : Scaffold(
                  backgroundColor: Color(0xFFF6BAA5),
                  body: Center(
                    child: SizedBox(
                      height: 200,
                      width: 350,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 20,
                        title: Text(
                          "Error",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          "NO INTERNET CONNECTION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
