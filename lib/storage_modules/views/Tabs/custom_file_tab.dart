import 'package:flutter/material.dart';

import '../widgets/recent_file.dart';
import '../widgets/recent_folder.dart';

class CustomFileTab extends StatelessWidget {
  const CustomFileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecentFile(),
        const SizedBox(height: 20),
        //  RecentFolder(),
      ],
    );
  }
}
