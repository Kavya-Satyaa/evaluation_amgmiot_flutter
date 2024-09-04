import 'package:evaluation_amgmiot/models/efficiency_info.dart';
import 'package:evaluation_amgmiot/services/get_api.dart';
import 'package:evaluation_amgmiot/utilities/global.dart';
import 'package:evaluation_amgmiot/views/issues_screen.dart';
import 'package:evaluation_amgmiot/views/login_screen.dart';
import 'package:evaluation_amgmiot/views/plant_details_screen.dart';
import 'package:flutter/material.dart';
import '../models/plant_info.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<PlantInfo> plants = [];
  EfficiencyInfo? allPlantsInfo;
  String dropdownValue = '';

  // Getting data from all plants' average efficiency and plant details
  getPlantDataAPI() async {
    allPlantsInfo = await ApiDataService()
        .getEfficiencyDetailFromApi("GetEfficiencyDetails");
    plants = await ApiDataService()
        .getDataFromApi(plants, "GetPlants", plantModelFromJson);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlantDataAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradient2,
        centerTitle: false,
        titleSpacing: 0,
        leading: Image.asset(
          'lib/assets/images/amgmiot_logo.png',
          scale: 3,
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
      body: allPlantsInfo == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : dashboardContent(),
    );
  }

  //Body of the dashboard screen
  dashboardContent() {
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
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Row(
                children: [
                  const Text(
                    'Hello User!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const IssuesScreen();
                        }));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'View Issues',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.3),
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    '${allPlantsInfo!.oee}%',
                    style: TextStyle(
                        color: Colors.yellowAccent.shade700,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  const Text(
                    'OEE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Divider(
                      thickness: 3,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        children: [
                          getOverallPlantDetails(allPlantsInfo!.totalMachines,
                              "Total Machines", Colors.white),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: VerticalDivider(
                              thickness: 1.3,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          getOverallPlantDetails(allPlantsInfo!.runningMachines,
                              "Running Machines", Colors.green),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: VerticalDivider(
                              thickness: 1.3,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          getOverallPlantDetails(allPlantsInfo!.stoppedMachines,
                              "Stopped Machines", Colors.red),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Your Plants',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: plants.length,
                  itemBuilder: (ctx, index) {
                    return plantListViewContent(plants[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //Modularised plant details based on API data
  Widget getOverallPlantDetails(int number, String info, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 20),
          ),
          Text(
            info,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  //Each plant detail list item
  Widget plantListViewContent(PlantInfo plant) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.008,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.darken),
              fit: BoxFit.cover,
              image: const AssetImage(
                "lib/assets/images/plants_image.png",
              )),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 10, top: 40, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.plantName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'OEE: ${plant.oee}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: selectPerformanceColor(plant.oee),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: const Color(0xff4E4E4E), width: 01)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PlantDetailsScreen(plant: plant);
                        }));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chevron_right,
                          size: 48,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
