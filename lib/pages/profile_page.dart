import 'package:expense_tracker/service/theme/theme_provider.dart';
import 'package:expense_tracker/util/profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  icon: Icon(Icons.person, size: 70),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'John doe',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'johndoe@gmail.com',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileTile(
                    leading: Icon(Icons.menu, size: 25),
                    title: 'Manage Categories',
                  ),

                  SizedBox(height: 10),
                  ProfileTile(
                    leading: Icon(Icons.file_upload_outlined, size: 25),
                    title: 'Export Data',
                  ),
                  SizedBox(height: 10),

                  ProfileTile(
                    leading: Icon(Icons.color_lens_outlined, size: 25),
                    title: 'Dark mode',
                    trailing: CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).isDarkMode,
                      onChanged: (value) => Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme(),
                    ),
                  ),
                  SizedBox(height: 10),

                  ProfileTile(
                    leading: Icon(Icons.logout_outlined, size: 25),
                    title: 'Logout ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
