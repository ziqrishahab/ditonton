import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTv;

  TvSearchBloc(this.searchTv) : super(TvSearchEmpty()) {
    on<OnTvQueryChanged>((event, emit) async {
      final query = event.query;

      if (query.isEmpty) {
        emit(TvSearchEmpty());
        return;
      }

      emit(TvSearchLoading());
      final result = await searchTv.execute(query);

      result.fold(
        (failure) => emit(TvSearchError(failure.message)),
        (data) => emit(TvSearchHasData(data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
