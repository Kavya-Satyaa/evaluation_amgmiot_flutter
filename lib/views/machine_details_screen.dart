import 'dart:math';
import 'package:evaluation_amgmiot/models/issue_details.dart';
import 'package:evaluation_amgmiot/models/machine_info.dart';
import 'package:flutter/material.dart';
import '../services/post_api.dart';
import '../utilities/global.dart';
import '../utilities/utilities.dart';
import 'login_screen.dart';

class MachineDetailsScreen extends StatefulWidget {
  const MachineDetailsScreen({super.key, required this.machine});
  final MachineInfo machine;

  @override
  State<MachineDetailsScreen> createState() {
    return _MachineDetailsScreenState();
  }
}

class _MachineDetailsScreenState extends State<MachineDetailsScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.machine.isBookmarked;
  }

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
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 25),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Log out':
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => const LoginScreen(),
                    ),
                    (route) =>
                        false,
                  );
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out'),
              ),
            ],
          )
        ],
      ),
      body: machineDetailsContent(),
    );
  }

  //Body content of the current screen
  Widget machineDetailsContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [gradient1, gradient2],
            stops: [0.8, 0.98],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter),
      ),
      child: Column(
        children: [
          Center(
            child: Hero(
              transitionOnUserGestures: true,
              tag: widget.machine.machineNo,
              child: Image.asset(
                'lib/assets/images/cnc_dummy.png',
                scale: 0.1,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: const Border(
                  top: BorderSide(
                    color: Color(0xff0079B5),
                    width: 4.0,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.20,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Machine ${widget.machine.machineNo}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Machine ${widget.machine.machineModel}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (isBookmarked) {
                                  await sendMachineFilesToApi(
                                      'UpdateBookmark',
                                      widget.machine.plantID,
                                      widget.machine.machineNo);
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                  showSnackBar(context,
                                      'Removed machine from Bookmarks!');
                                } else {
                                  await showConfirmationModal(widget.machine);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: isBookmarked
                                      ? const Icon(
                                          Icons.bookmark,
                                          color: Color(0xffFFBB00),
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.bookmark_border_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Divider(
                        thickness: 2,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),

                    const Text(
                      "About:",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffAEFF00),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        widget.machine.machineDescription,
                        maxLines: 8,
                        //textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    //),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Machine Status: ',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffAEFF00),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xff1E1E1E),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "OEE:  ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23),
                                      children: [
                                        TextSpan(
                                            text: "${widget.machine.oee}%",
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: selectPerformanceColor(
                                                  widget.machine.oee),
                                            ))
                                      ]),
                                ),
                                const Spacer(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: VerticalDivider(
                                    thickness: 1.5,
                                    color: Color(0xffFFFFFF),
                                  ),
                                ),
                                const Spacer(),
                                RichText(
                                  text: TextSpan(
                                      text: "Status:  ",
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: widget.machine.status,
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: widget.machine.status ==
                                                        "Running"
                                                    ? goodPerformanceColor
                                                    : badPerformanceColor))
                                      ],),
                                ),
                              ],
                            ),
                          ),
                        ),),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          Random random = Random(100);
                          IssueDetails issue = IssueDetails(
                              issueID:
                                  "${widget.machine.machineNo.substring(1, 4)}_${random.nextInt(999)}",
                              machineID: widget.machine.machineNo,
                              status: "Pending");
                          await sendIssueDetailsToApi('PostIssue', issue);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // backgroundColor: gradient2.withOpacity(0.7),
                                  title: const Text(
                                    'Ticket Raised',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  content: const Text(
                                    'Issue has been reported',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: gradient2),
                                        child: const Text(
                                          'Okay',
                                          style: TextStyle(fontSize: 20),
                                        ),),
                                  ],
                                );
                              });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff1E1E1E),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                color: Color(0xff7A0000),
                                width: 3,
                              ),),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Report an Issue',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Modal pop up for confirmation of adding machine as bookmark
  showConfirmationModal(MachineInfo machine) {
    ScaffoldMessenger.of(context).clearSnackBars();
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
              height: 100,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius:
                          10.0,
                      spreadRadius:
                          0.0,
                    )
                  ],
                ),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 5, left: 10),
                          child: const Text(
                            "Are you sure you want to Bookmark this machine?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 5, right: 5),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFBB00),
                                  ),
                                ),
                              ),
                            ),),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 5, right: 5),
                            child: TextButton(
                              onPressed: () async {
                                await sendMachineFilesToApi('UpdateBookmark',
                                    machine.plantID, machine.machineNo);
                                setState(() {
                                  isBookmarked = !isBookmarked;
                                });
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFBB00),
                                  ),
                                ),
                              ),
                            ),),
                      ],
                    )
                  ],
                ),
              ),);
        },);
  }
}
