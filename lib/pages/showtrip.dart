import 'dart:developer' show log;

import 'package:app_6/config/config.dart';
import 'package:app_6/model/response/trip_showtrip_get_res.dart';
import 'package:app_6/pages/profile.dart';
import 'package:app_6/pages/trip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  List<TripGetResponse> tripData = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getTrips();
    });
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == "logout") {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == "profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),

      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ปลายทาง', style: TextStyle(fontSize: 20)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              tripGetResponses = tripData;
                            });
                          },
                          child: Text(
                            'ทั้งหมด',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: FilledButton(
                          onPressed: () {
                            tripGetResponses = tripData;
                            List<TripGetResponse> euroTrips = [];

                            for (var trip in tripGetResponses) {
                              if (trip.destinationZone == 'เอเชีย') {
                                euroTrips.add(trip);
                                log(trip.country);
                              }
                            }

                            setState(() {
                              tripGetResponses = euroTrips;
                            });
                          },
                          child: Text('เอเชีย', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: FilledButton(
                          onPressed: () {
                            tripGetResponses = tripData;
                            List<TripGetResponse> euroTrips = [];

                            for (var trip in tripGetResponses) {
                              if (trip.destinationZone == 'ยุโรป') {
                                euroTrips.add(trip);
                                log(trip.country);
                              }
                            }

                            setState(() {
                              tripGetResponses = euroTrips;
                            });
                          },
                          child: Text('ยุโรป', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: FilledButton(
                          onPressed: () {
                            tripGetResponses = tripData;
                            List<TripGetResponse> euroTrips = [];

                            for (var trip in tripGetResponses) {
                              if (trip.destinationZone ==
                                  'เอเชียตะวันออกเฉียงใต้') {
                                euroTrips.add(trip);
                                log(trip.country);
                              }
                            }

                            setState(() {
                              tripGetResponses = euroTrips;
                            });
                          },
                          child: Text(
                            'อาเซียน',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: FilledButton(
                          onPressed: () {
                            tripGetResponses = tripData;
                            List<TripGetResponse> euroTrips = [];

                            for (var trip in tripGetResponses) {
                              if (trip.destinationZone == 'ประเทศไทย') {
                                euroTrips.add(trip);
                                log(trip.country);
                              }
                            }

                            setState(() {
                              tripGetResponses = euroTrips;
                            });
                          },
                          child: Text(
                            'ประเทศไทย',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: tripGetResponses.map((trip) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                trip.coverimage,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(trip.country),
                                  Text("ระยะเวลา ${trip.duration} วัน"),
                                  Text("ราคา ${trip.price} บาท"),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TripPage(idx: trip.idx),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.deepPurple.shade300,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: Text('รายละเอียดเพิ่มเติม'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
      tripData = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }
}
