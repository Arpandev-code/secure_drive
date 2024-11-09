import 'package:flutter/material.dart';

import '../widgets/storage_container.dart';
import '../widgets/upload_options.dart';

class CustomStorageTab extends StatelessWidget {
  const CustomStorageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const StorageContainer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        const UploadOptions(),
      ],
    );
  }
}
