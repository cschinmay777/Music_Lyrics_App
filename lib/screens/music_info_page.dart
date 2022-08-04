import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// const String urib="https://api.musixmatch.com/ws/1.1/track.get?track_id=TRACK_ID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7"
const String ApiKey = "abcc70b147b47acd7e686e904a144b77";

class MusicInfoPage extends StatefulWidget {
  int track_id;

  MusicInfoPage(this.track_id);

  @override
  State<MusicInfoPage> createState() => _MusicInfoPageState(
        this.track_id,
      );
}

class _MusicInfoPageState extends State<MusicInfoPage> {
  int track_id;
  String song_name = "";
  String artist_name = "";
  String album = "";
  int rating = 97;
  int explict = 0;
  String lyrics = "";
  bool isloaded = false;

  _MusicInfoPageState(this.track_id);
  StreamController<bool>? mStream = StreamController();

  @override
  initState() {
    super.initState();
    GetData_B();
  }

  void GetData_B() async {
    var uri_b = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=$track_id&apikey=$ApiKey");
    http.Response response_b = await http.get(uri_b);
    // print(response_b);
    var data = response_b.body;
    setState(() {
      song_name = jsonDecode(data)['message']['body']['track']['track_name'];
      artist_name = jsonDecode(data)['message']['body']['track']['artist_name'];
      album = jsonDecode(data)['message']['body']['track']['album_name'];
      rating = jsonDecode(data)['message']['body']['track']['track_rating'];
      explict = jsonDecode(data)['message']['body']['track']['explicit'];
    });

    var uri_c = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$track_id&apikey=$ApiKey");
    http.Response response_c = await http.get(uri_c);
    // print(response_b);
    var data_c = response_c.body;
    setState(() {
      lyrics = jsonDecode(data_c)['message']['body']['lyrics']['lyrics_body'];
      isloaded = true;
    });
    //print(data_c);
    //message.body.track.track_name
    //message.body.lyrics.lyrics_body
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF6BAA5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF6BAA5),
        elevation: 2,
        title: Text(
          "Track Details",
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
              color: Colors.deepOrangeAccent,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ), //Border.all
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3,
                                color: Color(0x64E0E3E7).withOpacity(.1),
                                offset: Offset(0, 2),
                                spreadRadius: 1)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              song_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.050),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 18, 10, 5),
                              child: Text(
                                "Artist",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black.withOpacity(.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 5, 10),
                              child: Text(
                                artist_name,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 10, 10, 5),
                              child: Text(
                                "Album Name",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black.withOpacity(.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 5, 10),
                              child: Text(
                                album,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 10, 10, 5),
                              child: Text(
                                "Explicit",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black.withOpacity(.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 5, 10),
                              child: Text(
                                (explict == 0) ? "False" : "True",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 10, 10, 5),
                              child: Text(
                                "Ratings",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black.withOpacity(.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 5, 10),
                              child: Text(
                                rating.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 10, 10, 10),
                              child: Text(
                                "Lyrics : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 15, 10, 10),
                              child: Text(
                                lyrics,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.7),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
