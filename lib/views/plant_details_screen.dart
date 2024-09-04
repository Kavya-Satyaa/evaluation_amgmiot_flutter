import 'package:evaluation_amgmiot/models/efficiency_info.dart';
import 'package:evaluation_amgmiot/models/machine_info.dart';
import 'package:evaluation_amgmiot/models/plant_info.dart';
import 'package:evaluation_amgmiot/services/get_api.dart';
import 'package:evaluation_amgmiot/views/machine_details_screen.dart';
import 'package:flutter/material.dart';
import '../services/post_api.dart';
import '../utilities/global.dart';
import '../utilities/utilities.dart';
import 'login_screen.dart';

class PlantDetailsScreen extends StatefulWidget {
  const PlantDetailsScreen({super.key, required this.plant});

  final PlantInfo plant;

  @override
  State<PlantDetailsScreen> createState() {
    return _PlantDetailsScreenState();
  }
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  EfficiencyInfo? planInfo;
  List<MachineInfo> fmachines = [];
  List<MachineInfo> machines = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  getPlantDetails() async {
    planInfo = await ApiDataService().getEfficiencyDetailFromApi(
        "getEfficiencyDetails?plant=${widget.plant.plantName}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlantDetails();
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
      body: plantDetailsContent(),
    );
  }

  //Body of the current screen
  Widget plantDetailsContent() {
    if (planInfo == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planInfo!.plantName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${planInfo!.oee}%",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: selectPerformanceColor(planInfo!.oee),
                            ),
                          ),
                          const Text(
                            'OEE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Total Machines ',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                planInfo!.totalMachines.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Text(
                                'Running Machines ',
                                style: TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              Text(
                                planInfo!.runningMachines.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: goodPerformanceColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Stopped Machines ',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                planInfo!.stoppedMachines.toString(),
                                style: const TextStyle(
                                    color: badPerformanceColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Divider(
                  thickness: 3,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: getMachines(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        //print(snapshot.data?.length);
                        if (snapshot.data == null) {
                          return const Text("No Data");
                        } else {
                          machines = snapshot.data!;
                          machines.sort((a, b) {
                            if (b.isBookmarked) {
                              return 1;
                            }
                            return -1;
                          });
                          return RefreshIndicator(
                            key: _refreshIndicatorKey,
                            color: Colors.white,
                            backgroundColor: gradient2,
                            strokeWidth: 4.0,
                            onRefresh: refreshData,
                            child: ListView.builder(
                                itemCount: machines.length,
                                itemBuilder: (ctx, index) {
                                  return machineListView(machines[index]);
                                }),
                          );
                        }
                      } else {
                        return const Text("Error occurred");
                      }
                    }),
              )
            ],
          ),
        ),
      );
    }
  }

  //Future list that populates once API data is retrieved
  Future<List<MachineInfo>> getMachines() async {
    String reqURL = "GetPlantMachines?plant=${widget.plant.plantName}";
    fmachines = await ApiDataService()
        .getDataFromApi(fmachines, reqURL, machineModelFromJson);
    return fmachines;
  }

  //Each machine list view item
  machineListView(MachineInfo machine) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MachineDetailsScreen(
                      machine: machine,
                    )),
          ).then((value) => setState(() {}));
        },
        child: Container(
            height: MediaQuery.of(context).size.height * 0.16,
            width: double.infinity,
            decoration: BoxDecoration(
                //border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                // color: Colors.grey.shade800.withOpacity(0.6)
                color: Colors.white.withOpacity(0.15)),
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: machine.status == "Running"
                            ? goodPerformanceColor
                            : badPerformanceColor,
                        width: 1.3),
                    color: const Color(0xff090821),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Hero(
                    tag: machine.machineNo,
                    child: Image.asset(
                      'lib/assets/images/cnc_dummy.png',
                      scale: 0.8,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Machine ${machine.machineNo}",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Machine ${machine.machineModel}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'OEE:  ${machine.oee}%',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: selectPerformanceColor(machine.oee)),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () async {
                                if (machine.isBookmarked) {
                                  await sendMachineFilesToApi('UpdateBookmark',
                                      machine.plantID, machine.machineNo);
                                  showSnackBar(context,
                                      'Removed machine from Bookmarks!');
                                  setState(() {});
                                } else {
                                  showConfirmationModal(machine);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: machine.isBookmarked
                                        ? const Icon(
                                            Icons.bookmark,
                                            color: Color(0xffFFBB00),
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.bookmark_border_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //Confirmation before bookmarking a machine
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
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFBB00),
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 5, right: 5),
                            child: TextButton(
                              onPressed: () async {
                                await sendMachineFilesToApi('UpdateBookmark',
                                    machine.plantID, machine.machineNo);
                                setState(() {});
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2)),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFBB00),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  //Refreshing the machine list items
  Future<void> refreshData() async {
    machines = await getMachines();
    setState(() {});
  }
}
