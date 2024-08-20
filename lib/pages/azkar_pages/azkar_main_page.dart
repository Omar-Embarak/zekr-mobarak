import 'package:azkar_app/cubit/azkar_cubit/azkar_cubit.dart';
import 'package:azkar_app/cubit/azkar_cubit/azkar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/colors.dart';
import '../../utils/app_images.dart';
import 'zekr_page.dart';

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  @override
  void initState() {
    super.initState();
    final azkarCubit = context.read<AzkarCubit>();
    azkarCubit.loadAzkar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: const Text(
          "الأذكار",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: ((context, state) {
          if (state is AzkarLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is AzkarLoaded) {
            return GridView.builder(
                itemCount: state.azkar.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ZekrPage(
                              zekerCategory: state.azkar[index].category!,
                              zekerList: state.azkar[index].array!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.kSecondaryColor),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${state.azkar[index].category}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                    Assets.imagesArrowRight),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else if (state is AzkarError) {
            return const Center(
              child: Text("حديث خطأ في تحميل الأذكار"),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
