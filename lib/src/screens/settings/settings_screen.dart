import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth.dart';
import '../../service/workout_program_service.dart';
import '../home_screen.dart'; // Ensure AppColors class is defined.

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isSaveVisible = false;
  bool _isProfileExpanded = false;

  void customLaunch(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (kDebugMode) {
          print('Cannot launch $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching $url: $e');
      }
    }
  }

  Future<void> _deleteAccountAndData() async {
    try {
      final fetchedExerciseDayList =
          await WorkoutProgramService().deleteAccountAndData();
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }

  void _toggleSaveButton(String value) {
    setState(() {
      _isSaveVisible = _usernameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty;
    });
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileExpansionTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.LIGHT_BLACK,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ExpansionTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
            size: 30.sp,
          ),
          title: Text(
            'Profile Summary',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          trailing: Icon(
            _isProfileExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 28.sp,
          ),
          initiallyExpanded: _isProfileExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isProfileExpanded = expanded;
            });
          },
          children: [
            // Add the Save Changes button at the top-right of the expanded tile
            Stack(
              children: [
                // Profile Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField(
                      label: 'Username',
                      controller: _usernameController,
                      onChanged: _toggleSaveButton,
                    ),
                    Divider(color: Colors.grey[600]),
                    _buildProfileField(
                      label: 'Email',
                      controller: _emailController,
                      onChanged: _toggleSaveButton,
                    ),
                    Divider(color: Colors.grey[600]),
                    _buildProfileField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: _toggleSaveButton,
                    ),
                  ],
                ),
                // Save button positioned on the top-right of the expanded section
                if (_isSaveVisible)
                  Positioned(
                    top: 0,
                    right: 10.w,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h), // Adjust padding if needed
      child: SizedBox(
        height: 40.h, // Reduced height for the ListTile
        width: double.infinity, // Full width
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: Colors.white,
            size: 18.sp, // Slightly smaller icon size
          ),
          title: Text(
            label,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 16.sp, // Slightly smaller text size
                color: Colors.white,
              ),
            ),
          ),
          tileColor: AppColors.LIGHT_BLACK, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w, // Adjust horizontal padding if necessary
            vertical: 0.h, // Minimized vertical padding to center content
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.DARK_BACKGROUND,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h), // Added gap above profile
              _buildProfileExpansionTile(),
              SizedBox(height: 15.h),
              Text(
                'Settings',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _buildSettingsTile(
                icon: Icons.star_rate,
                label: 'Rate Us',
                onTap: () {
                  customLaunch(
                      'https://play.google.com/store/apps/details?id=com.weightloss.fluentfitness');
                },
              ),
              _buildSettingsTile(
                icon: Icons.feedback,
                label: 'Feedback',
                onTap: () {
                  customLaunch(
                      'mailto:fluentfitness9@gmail.com?subject=Feedback on Fluent Fitness App');
                },
              ),
              _buildSettingsTile(
                icon: Icons.share,
                label: 'Share with Friends',
                onTap: () {
                  Share.share(
                      'Hey, This app is awesome for home workouts and diets.\nLet\'s get into shape together! Worth a try.\n\nDownload this app\nhttps://play.google.com/store/apps/details?id=com.weightloss.fluentfitness ');
                },
              ),
              _buildSettingsTile(
                icon: FontAwesomeIcons.instagram,
                label: 'Follow us on Instagram',
                onTap: () {
                  customLaunch('https://www.instagram.com/fluentfitness_/');
                },
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_rounded,
                label: 'Terms & Condition',
                onTap: () {
                  customLaunch('https://www.instagram.com/fluentfitness_/');
                },
              ),
              _buildSettingsTile(
                icon: Icons.logout,
                label: 'Log Out',
                onTap: () {
                  context.read<AuthProvider>().logout();
                  context.read<HomeScreen>();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              _buildSettingsTile(
                icon: Icons.delete,
                label: 'Delete Account',
                onTap: () async {
                  await _deleteAccountAndData();
                  context.read<AuthProvider>().logout();
                  context.read<HomeScreen>();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        home: SettingsScreen(),
      ),
    ),
  );
}
