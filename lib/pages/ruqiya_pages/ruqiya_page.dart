import 'package:azkar_app/cubit/ruqiya_cubit/ruqiya_cubit.dart';
import 'package:azkar_app/methods.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class RuqiyaPage extends StatefulWidget {
  const RuqiyaPage({super.key});

  @override
  State<RuqiyaPage> createState() => _RuqiyaPageState();
}

class _RuqiyaPageState extends State<RuqiyaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RuqiyaCubit()
        ..loadRuqiya(), // Ensure cubit is provided and loadRuqiya is called
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: AppStyles.styleDiodrumArabicbold20(context).color),
          backgroundColor: AppColors.kSecondaryColor,
          centerTitle: true,
          title: Text(
            "الرقية الشرعية",
            style: AppStyles.styleDiodrumArabicbold20(context),
          ),
        ),
        body: BlocBuilder<RuqiyaCubit, RuqiyaState>(
          builder: ((context, state) {
            if (state is RuqiyaLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is RuqiyaLoaded) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: state.ruqiya.length,
                  itemBuilder: (context, index) {
                    return RuqiyaItem(
                      text: state.ruqiya[index].text!,
                      info: state.ruqiya[index].info!,
                    );
                  },
                ),
              );
            } else if (state is RuqiyaError) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else {
              return Container();
            }
          }),
        ),
      ),
    );
  }
}

class RuqiyaItem extends StatelessWidget {
  const RuqiyaItem({super.key, re, required this.text, required this.info});
  final String text;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: .3,
            )
          ],
          borderRadius: BorderRadius.circular(12),
          color: AppColors.kSecondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  textAlign: TextAlign.justify,
                  style: AppStyles.styleDiodrumArabicbold20(context)),
              Divider(
                color: AppColors.kPrimaryColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info,
                    textAlign: TextAlign.justify,
                    style: AppStyles.styleDiodrumArabicbold20(context),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      showMessage("تم النسخ بنجاح للحافظة");
                    },
                    icon: Icon(
                      Icons.copy,
                      color: AppStyles.styleDiodrumArabicbold20(context).color,
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
