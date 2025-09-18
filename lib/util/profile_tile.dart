import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget? trailing;
  const ProfileTile({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),

      leading: leading,
      trailing: trailing,
    );
  }
}
