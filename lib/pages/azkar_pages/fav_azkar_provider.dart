// import 'package:azkar_app/database_helper.dart';
// import 'package:flutter/material.dart';

// import '../../constants.dart';

// class FavAzkarPage extends StatelessWidget {
//    FavAzkarPage({super.key});
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorite Azkar'),
//         backgroundColor: AppColors.kSecondaryColor,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _databaseHelper.getFavsAzkar(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No favorites yet.'));
//           } else {
//             final favorites = snapshot.data!;
//             return ListView.builder(
//               itemCount: favorites.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(favorites[index]['category']),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () async {
//                       await _databaseHelper.deleteFavAzkar(
//                           favorites[index]['category']);
//                       (context as Element).markNeedsBuild();
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
