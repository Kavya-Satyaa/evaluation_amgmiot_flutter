# AMG-mIoT

The AMG=mIoT is a versatile app that helps our customers track information of their machines including the working status, Overall Equipment Efficiency(OEE) and allows raising issues in case of any discrepancies. 

## Screens
 1. Login Screen
 2. User Plant Dashboard
 3. Plant Machine Screen
 4. Machine Detail Screen
 5. View Issues Screen

## Features
 1. Inititally, the user is displayed with a login screen where he must enter valid credentials to be redirected to the user dashboard.
 2. The user dashboard shows all the plants present in the company and their overall efficiencies respectively. It also contains the View Issues button which redirects him to the list of issues raised and their current status.
 3. Each plant under dashboard when clicked, redirects him to the screen with information of all individual machines present under the plant. These machines can be bookmarked to be easily accessible later.
 4. Each machine again redirects the user to a detailed view of the machine displaying properties of that machine. If any discrepancies are found, an issue can be raised by the user immediately.
 5. The user can logout at any given time by simply clicking on the options button present in the app bar and selecting 'Log out'.

## Installation
Follow these steps to install and run evaluation_amgmiot_flutter on your system.
 ### Clone the Repository
  1. Open your terminal or command prompt.
  2. Use the following command to clone the evaluation_amgmiot_flutter repository:
     
      `git clone https://github.com/Kavya-Satyaa/evaluation_amgmiot_flutter.git`
 ### Configuration and Implementation
  1. Change your working directory to the cloned repository:
     
      `cd evaluation_amgmiot_flutter`

  2. Install the required dependencies present in the pubspec.yaml using the following command:

     `flutter pub add get`
     
  3. Connect your device or start an emulator.
  4. To build and run the project, use the following command:

      `flutter run`
     
      This will build the project and install it on your connected device or emulator.
  5. To build the apk version of the app, run the following command on terminal:

     `flutter build apk`
     
  6. Once the command has been run on terminal, follow the path in the folder and install it on your desired device:

     `evaluation_amgmiot_flutter/build/app/outputs/flutter-apk/app-release.apk`


 
