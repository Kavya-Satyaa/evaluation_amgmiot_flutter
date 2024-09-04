import 'dart:developer';
import 'package:evaluation_amgmiot/models/issue_details.dart';
import 'package:evaluation_amgmiot/services/get_api.dart';
import 'package:flutter/material.dart';
import '../utilities/global.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() {
    return _IssuesScreenState();
  }
}

class _IssuesScreenState extends State<IssuesScreen> {
  List<IssueDetails> issuesList = [];
  List<IssueDetails> printList = [];
  Widget? dContent;
  int _selectedIndex = 0;
  Map<int, String> status = {0: "All", 1: "Pending", 2: "Resolved"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradient2,
        centerTitle: false,
        titleSpacing: 0,
        title: Image.asset(
          'lib/assets/images/amgmiot_logo.png',
          scale: 7,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [gradient1, gradient2],
              stops: [0.8, 0.98],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View Issues',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  getElevatedButton(title: 'All', index: 0),
                  getElevatedButton(title: 'Pending', index: 1),
                  getElevatedButton(title: 'Resolved', index: 2),
                ],
              ),
              dContent == null
                  ? displayedContent(status[_selectedIndex]!)
                  : dContent!,
            ],
          ),
        ),
      ),
    );
  }

  //Used to toggle status buttons based on selected index
  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
      dContent = displayedContent(status[index]!);
    });
  }

  //Modularising the  code to design elevated buttons for status selection
  Widget getElevatedButton({required String title, required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.3),
      child: ElevatedButton(
        onPressed: () => _selectButton(index),
        style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 1, color: Color(0xff0088BE)),
            //minimumSize: Size(130, 30),
            minimumSize: Size(MediaQuery.of(context).size.width * 0.29,
                MediaQuery.of(context).size.height * 0.033),
            backgroundColor: _selectedIndex == index
                ? const Color(0xff005A7D)
                : Colors.transparent),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  //Future list to populate IssueDetails once received from API
  Future<List<IssueDetails>> getIssues() async {
    String reqURL = "GetIssueList";
    issuesList = await ApiDataService()
        .getDataFromApi(issuesList, reqURL, issueModelFromJson);
    for (var x in issuesList) {
      log(x.status);
    }
    return issuesList;
  }

  //Changing the displayed Issue details based on status selected by user
  Widget displayedContent(String status) {
    return Expanded(
        child: FutureBuilder(
            future: getIssues(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return const Text("No Data");
                } else {
                  printList = snapshot.data!;
                  printList = (status == "All")
                      ? issuesList
                      : (issuesList
                          .where((issue) => issue.status == status)
                          .toList());
                  return ListView.builder(
                      itemCount: printList.length,
                      itemBuilder: (ctx, index) {
                        return issueListItem(printList[index]);
                      });
                }
              } else {
                return const Text("Error occurred");
              }
            },),);
  }

  //Each issue item present in the list of selected status
  Widget issueListItem(IssueDetails issue) {
    MaterialColor getColor(String status) {
      return (status == "Pending") ? Colors.red : Colors.green;
    }

    Widget getIcon(String status) {
      return (status == "Pending")
          ? Image.asset(
              'lib/assets/images/cross.png',
              color: Colors.red,
              scale: 1,
            )
          : Image.asset(
              'lib/assets/images/tick.png',
              color: Colors.green,
              scale: 1,
            );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.085,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: Center(
                    child: getIcon(issue.status),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${issue.issueID}_${issue.status}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColor(issue.status),
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Machine ${issue.machineID}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: 15.0, top: 20, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 25,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
