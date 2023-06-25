import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/constants.dart';
import 'package:flutter_app_1/widget/profile_widget.dart';

import '../../screens/signin_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    print('Signed Out');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 2000,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: ExactAssetImage('assets/profile_icon.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * .3,
                child: Row(
                  children: [
                    Text(
        FirebaseAuth.instance.currentUser?.displayName ?? '', 
        style: TextStyle(
          color: Constants.blackColor,
          fontSize: 20,
        ),
                    ),
                    // SizedBox(
                    //   height: 24,
                    //   child: Image.asset("assets/verified.png"),
                    // ),
                  ],
                ),
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? '', // Adresa de email a utilizatorului
        style: TextStyle(
          color: Constants.blackColor,
          fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileWidget(
                      icon: Icons.person,
                      title: 'My Profile',
                    ),
                    ProfileWidget(
                      icon: Icons.settings,
                      title: 'Settings',
                    ),
                    ProfileWidget(
                      icon: Icons.notifications,
                      title: 'Notifications',
                    ),
                   
                    ProfileWidget(
                      icon: Icons.share,
                      title: 'Share',
                    ),
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Constants.blackColor.withOpacity(.5),
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Constants.blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.blackColor.withOpacity(.4),
                              size: 16,
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
        ),
      ),
    );
  }
}
