import 'package:azkar_app/cubit/azkar_cubit/azkar_cubit.dart';
import 'package:azkar_app/cubit/azkar_cubit/azkar_state.dart';
import 'package:azkar_app/pages/azkar_pages/fav_azkar_page.dart';
import 'package:azkar_app/widgets/reciturs_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../model/azkar_model/azkar_model/azkar_model.dart';
import '../../utils/app_style.dart';
import 'zekr_page.dart';

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AzkarModel> filteredAzkar = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final azkarCubit = context.read<AzkarCubit>();
    azkarCubit.loadAzkar();
    filteredAzkar = [];
  }

  void _filterAzkar(String query) {
    final azkarCubit = context.read<AzkarCubit>();
    if (azkarCubit.state is AzkarLoaded) {
      final azkarList = (azkarCubit.state as AzkarLoaded).azkar;
      setState(() {
        filteredAzkar = azkarList
            .where((azkar) =>
                azkar.category != null &&
                azkar.category!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        final azkarCubit = context.read<AzkarCubit>();
        if (azkarCubit.state is AzkarLoaded) {
          filteredAzkar =
              (azkarCubit.state as AzkarLoaded).azkar; // Reset to all Azkar
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppStyles.styleCairoMedium15white(context).color),
        backgroundColor: AppColors.kSecondaryColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterAzkar,
                style: AppStyles.styleCairoMedium15white(context),
                decoration: InputDecoration(
                  hintText: 'إبحث عن ذكر ...',
                  hintStyle: AppStyles.styleCairoMedium15white(context),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                'الأذكار',
                style: AppStyles.styleCairoBold20(context),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: _toggleSearch,
                child: Icon(_isSearching ? Icons.close : Icons.search)),
          )
        ],
      ),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (context, state) {
          if (state is AzkarLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is AzkarLoaded) {
            final azkarToDisplay = _isSearching ? filteredAzkar : state.azkar;

            return ListView.builder(
              itemCount: azkarToDisplay.length + 1, // +1 for extra item
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Add the extra item
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FavAzkarPage(),
                        ),
                      );
                    },
                    child: const RecitursItem(
                      title: "أذكاري المفضلة",
                    ),
                  );
                }

                final actualIndex = index - 1; // Adjust index for azkar list
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ZekrPage(
                          zekerCategory: azkarToDisplay[actualIndex].category!,
                          zekerList: azkarToDisplay[actualIndex].array!,
                        ),
                      ),
                    );
                  },
                  child: RecitursItem(
                    title: "${azkarToDisplay[actualIndex].category}",
                  ),
                );
              },
            );
          } else if (state is AzkarError) {
            return const Center(
              child: Text("حدث خطأ في تحميل الأذكار"),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
