import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

class PopUpUlasanScreen extends StatefulWidget {
  const PopUpUlasanScreen({super.key});

  @override
  _PopUpUlasanScreenState createState() => _PopUpUlasanScreenState();
}

class _PopUpUlasanScreenState extends State<PopUpUlasanScreen> {
  int? selectedEmoji;
  final TextEditingController _reasonController = TextEditingController();

  void _submitReview() {
    if (selectedEmoji != null && _reasonController.text.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Ulasan Terkirim!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.c2a6892,
        textColor: Colors.white,
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg: "Harap pilih emoji dan isi alasan!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Beri Ulasan Untuk Kami!',
                style: AppTextStyles.heading_4_bold.copyWith(
                  color: AppColors.c2a6892,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Bagaimana pendapat kamu terhadap aplikasi ini? pilih salah satu emoji yang bisa merepresentasikan mood kamu!',
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph_14_regular.copyWith(
                  color: AppColors.c3585ba,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEmoji = index;
                      });
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          selectedEmoji == index
                          
                              ? AppColors.c2a6892
                              : Colors.transparent,
                      child: Image.asset(
                        'assets/images/emoji$index.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Ketik alasanmu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppColors.c2a6892),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: AppTextStyles.paragraph_14_medium.copyWith(
                        color: AppColors.c2a6892,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2a6892,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: AppTextStyles.paragraph_14_medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
