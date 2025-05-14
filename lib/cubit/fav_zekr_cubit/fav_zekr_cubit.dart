import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fav_zekr_state.dart';

class FavZekrCubit extends Cubit<FavZekrState> {
  FavZekrCubit() : super(FavZekrInitial());
}
