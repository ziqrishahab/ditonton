import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class OnTheAirTvBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnTheAirTv getOnTheAirTv;

  OnTheAirTvBloc(this.getOnTheAirTv) : super(TvListEmpty()) {
    on<FetchOnTheAirTv>((event, emit) async {
      emit(TvListLoading());
      final result = await getOnTheAirTv.execute();
      result.fold(
        (failure) => emit(TvListError(failure.message)),
        (tvs) => emit(TvListHasData(tvs)),
      );
    });
  }
}
