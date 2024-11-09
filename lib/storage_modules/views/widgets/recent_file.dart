import 'package:flutter/material.dart';

class RecentFile extends StatelessWidget {
  const RecentFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Files",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return fileView(
                    context: context,
                    fileName: "File Name$index",
                    image: "https://picsum.photos/200/200?random=$index",
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget fileView({
    required BuildContext context,
    required String fileName,
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        height: 70,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                image: NetworkImage(
                  image,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              fileName,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
