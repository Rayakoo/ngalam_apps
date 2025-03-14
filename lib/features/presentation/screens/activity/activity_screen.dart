import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Page"),
        backgroundColor:
            AppColors.cce1f0, // Set the AppBar color to secondary color
      ),
      body: Center(
        child: Image.network(
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.explicit.bing.net%2Fth%3Fid%3DOIP.z7hczHvzGF5s2S7UYcaruwHaJT%26pid%3DApi&f=1&ipt=c3df8ebfe8d5d39efbc6d6ea29bd5d720537f5829b83c97be8e3a6781c37bd14&ipo=images',
          errorBuilder: (context, error, stackTrace) {
            return Text('Failed to load image');
          },
        ),
      ),
    );
  }
}
