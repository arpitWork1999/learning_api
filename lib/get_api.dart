import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:learning_api/model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SamplePosts> samplePosts = [];
  String result = '';
  final idController = TextEditingController();
  final userIdController = TextEditingController();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  void clearText() {
    idController.clear();
    userIdController.clear();
    titleController.clear();
    bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
        "API SCREEN",
        style: GoogleFonts.fredoka(fontSize: 30.sp, fontWeight: FontWeight.w500),
      )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                  return containerCard(
                      "${samplePosts[index].userId}",
                      "${samplePosts[index].id}",
                      "${samplePosts[index].title}",
                      "${samplePosts[index].body}");
                });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                arpitDilogbox(context);
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 0, 0, 0),
              )),
          label: "ADD DATA",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 0, 0, 0),
              )),
          label: "DELETE DATA",)
      ]),
    );
  }

  Future<List<SamplePosts>> getData() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        samplePosts.add(SamplePosts.fromJson(index));
      }
      return samplePosts;
    } else {
      return samplePosts;
    }
  }

  Future<SamplePosts> postData(
      {required int id,
      required int userId,
      required String title,
      required body,
      required Function onUpdate}) async {
    try {
      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        body: {
          "userId": userId.toString(),
          "id": id.toString(),
          "title": title,
          "body": body
        },
      );
      if (response.statusCode == 201) {
        log("response----${response.body}");
        onUpdate();
        return SamplePosts.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        log("error----${e.toString()}");
      });
      throw Exception('An error occurred: $e');
    }
  }

  Widget containerCard(
      String? id, String? userId, String? title, String? body) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GET API DATA",
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp, fontWeight: FontWeight.w500)),
                          Icon(Icons.edit)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID:- ${id ?? ""}",
                      maxLines: 1,
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  Text("USER ID:- ${userId ?? ""}",
                      maxLines: 1,
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  Text("TITLE:- ${title ?? ""} ",
                      maxLines: 1,
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  Text("BODY:- ${body ?? ""}",
                      maxLines: 2,
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------------------ADD DATA(Dialouge Box)----------------------------------//
  void arpitDilogbox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text("Add Data",
                    style: GoogleFonts.fredoka(
                        fontSize: 30.sp, fontWeight: FontWeight.w400)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    clearText();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                  ),
                )
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Id',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter UserId',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Title',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bodyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Body',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      int id = int.parse(idController.text.toString().trim());
                      int userID =
                          int.parse(userIdController.text.toString().trim());
                      String title = titleController.text.trim();
                      String body = bodyController.text.trim();

                      await postData(
                          id: id,
                          userId: userID,
                          title: title,
                          body: body,
                          onUpdate: () {
                            clearText();
                            Navigator.pop(context);
                          });
                      clearText();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.grey),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Save",
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
