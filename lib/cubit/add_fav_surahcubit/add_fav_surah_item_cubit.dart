import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_fav_surah_item_state.dart';

class AddFavSurahItemCubit extends Cubit<AddFavSurahItemState> {
  AddFavSurahItemCubit() : super(AddFavSurahItemInitial());
}
