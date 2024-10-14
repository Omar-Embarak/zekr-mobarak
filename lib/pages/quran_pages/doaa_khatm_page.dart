import 'package:azkar_app/constants.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DoaaKhatmPage extends StatelessWidget {
  const DoaaKhatmPage({super.key});

  final String _doaaText = '''
    اللهم اجعل القرآن ربيع قلوبنا، ونور صدورنا، وجلاء أحزاننا، وذهاب همومنا وغمومنا، وسابقنا إلى رضوانك. 
    اللهم اجعلنا ممن يتلون كتابك آناء الليل وأطراف النهار، ويعملون بما فيه، ويهتدون بهديه. 
    اللهم اجعل القرآن شفيعًا لنا يوم القيامة، وسائقًا لنا إلى الجنة، وحاجزًا لنا عن النار. 
    اللهم اجعلنا من أهل القرآن الذين هم أهلك وخاصتك، واجعلنا من التالين له والمتدبرين لمعانيه. 
    اللهم ارزقنا فهمه والعمل به وتطبيقه في حياتنا. 
    اللهم اجعلنا من الذين يستمعون القول فيتبعون أحسنه، وارزقنا السكينة والطمأنينة به.
    ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دعاء ختم القرآن',
            style: AppStyles.styleRajdhaniBold18(context)
                .copyWith(color: Colors.white)),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(_doaaText,
                  textDirection: TextDirection.rtl,
                  style: AppStyles.styleRajdhaniBold20(context)
                      .copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _shareDoaa();
        },
        backgroundColor: AppColors.kSecondaryColor,
        child: const Icon(Icons.share),
      ),
    );
  }

  void _shareDoaa() {
    Share.share(
      _doaaText,
      subject: 'دعاء ختم القرآن',
    );
  }
}
