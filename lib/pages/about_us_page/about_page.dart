// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // Method to launch email app
  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2120303@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  void _launchEmail2() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2138017@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  void _launchEmail3() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2112240@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  void _launchEmail4() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2125866@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  void _launchEmail5() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2157506@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  void _launchEmail6() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'up2060987@myport.ac.uk',
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(fontSize: 45)), //title
        backgroundColor: Colors.green, //background
        toolbarHeight: MediaQuery.of(context).size.height * 0.06,
        shape: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
      ),
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009), //s
                //main container - FIXED: Removed extreme height that caused overflow
                Container(
                  // height: MediaQuery.of(context).size.height * 3.2, //REMOVED: This was causing layout overflow
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[700],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    //about us paragraph
                    const Text(
                      'WasteAway is an exciting new application designed to help cut down on food waste. In the United Kingdom, approximately 9.5 million tonnes of food go to waste each year, a staggering amount. Meanwhile, 8.4 million people in the UK struggle with food poverty. It\'s a heartbreaking paradox: while so much food is discarded, many individuals and families are left without enough to eat.\n\n'
                      'Our aim is to significantly reduce the amount of food waste being produced. This is beneficial to both the environment and saving money.\n\n'
                      'Less wasted food means fewer resources used in production. Further environmental benefits include reducing Greenhouse Gas Emissions, Rotting food in landfills produces methane, a potent greenhouse gas. Cutting waste helps mitigate climate change. Wasting less food means more money in our pockets.\n\n'
                      'The WasteAway application allows you to enter ingredients that you need to use before their "use by date" expires. Simply enter the ingredients you have into the App and you will be guided to exciting recipes that use what you have available. No more chucking out that "half a pineapple" or "pack of cream cheese". This is the App that every household needs.',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // First Container - FIXED: Removed DecorationImage, just show icon
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black), // Black outline
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the left
                                children: [
                                  //image container for profiles - FIXED: Removed problematic image, kept fallback
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors
                                              .black), // Black outline for image
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Josh Varney',
                                            ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'All-round Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am Josh, I helped develope this app, enjoy our application feel free to email me about it.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail2, //email link
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Second Container - FIXED: Removed problematic image, kept fallback
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hazaloid Jenkins',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Front-end Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am haz, I helped develope this app, i like tattoos and scarface. Feel free to email me if you have any enquiries about our app.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail,
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // third Container - FIXED: Removed problematic image, kept fallback
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Mattew Bowers',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Back-end Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am Matt, I helped develope this app, please allow it to improve your eating. Email one of the team if you have enquiries.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail3,
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // forth Container - FIXED: Removed problematic image, kept fallback
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Rhys Parsons',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Front-end Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am Rhys, I helped develope this app, email me or the team about anything related to our app.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail4,
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          //new row
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // fifth Container - FIXED: Removed problematic image, kept fallback
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Khadija Baffa',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'All-round Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am Khadija, I helped develope this app, please email with any questions.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail5,
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // sixth container - FIXED: Removed problematic image, kept fallback
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.45,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // Fallback color
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Cindy Murimi',
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Back-end Developer',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          const Expanded(
                                            child: Text(
                                              'I am Cindy, I helped develope this app. If there is anything you are unsure about, you can speak to me or one of the team.',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _launchEmail6,
                                            child: const Text(
                                              'Contact by email',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }}