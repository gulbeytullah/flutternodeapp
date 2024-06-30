import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Box? noteBox;

  @override
  void initState() {
    super.initState();
    boxOpen();
  }

  void boxOpen() async {
    noteBox = await Hive.openBox("notes");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 52, 121),
      body: noteBox != null
          ? ValueListenableBuilder(
              valueListenable: noteBox!.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      "No notes available.",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  );
                }

                final values = box.values.toList();
                values.sort((b, a) => a["date"].compareTo(b["date"]));

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 38,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/note.png',
                            width: 50,
                          ),
                          Column(
                            children: [
                              Text(
                                "Not Defteri",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${values.length} Adet Not",
                                style: TextStyle(
                                  fontFamily: 'Intel',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GridView.custom(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            repeatPattern: QuiltedGridRepeatPattern.inverted,
                            pattern: [
                              QuiltedGridTile(2, 2),
                              QuiltedGridTile(1, 1),
                              QuiltedGridTile(1, 1),
                            ],
                          ),
                          childrenDelegate: SliverChildBuilderDelegate(
                            childCount: values.length,
                            (context, index) => Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 53, 35, 94),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  Text(
                                    values[index]["title"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      values[index]["note"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Intel",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 53, 52, 121),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
