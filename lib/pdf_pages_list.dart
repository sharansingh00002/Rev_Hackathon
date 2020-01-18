import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api_repo.dart';
import 'package:flutter_app/detailed_page.dart';
import 'package:flutter_app/model.dart';

class PdfPagesList extends StatefulWidget {
  @override
  _PdfPagesListState createState() => _PdfPagesListState();
}

class _PdfPagesListState extends State<PdfPagesList> {
  List<UserSharedCampaignsList> model;
  @override
  void initState() {
    ApiRepo().getPdfLists().then((data) {
      setState(() {
        model = data;
      });
    });
    Future.delayed(Duration(seconds: 5), () {
      ApiRepo().getPdfLists().then((data) {
        if (context != null && mounted) {
          setState(() {
            model = data;
          });
        }
      });
    });

    super.initState();
  }

  Future<void> refresh() async {
    return ApiRepo().getPdfLists().then((data) {
      setState(() {
        model = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded Pdfs'),
      ),
      body: (model != null)
          ? RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                        ApiRepo()
                            .downloadFile(
                                '${model[index].fileName}${model[index].id.oid}')
                            .then((val) async {
                          Navigator.pop(context);
                          File file = File(val);
                          String contents = await file.readAsString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedPage(
                                        text: contents,
                                      )));
//                          OpenFile.open(val);
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  model[index].fileName ?? 'File',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(36.0),
                                            color: (model[index].status == 0)
                                                ? Colors.redAccent
                                                : Colors.green,
                                          ),
                                          child: Center(
                                            child: Text(
                                              (model[index].status == 0)
                                                  ? 'Processing'
                                                  : 'Checkout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: model.length,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
