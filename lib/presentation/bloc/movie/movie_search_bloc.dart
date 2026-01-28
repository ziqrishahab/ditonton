import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc(this.searchMovies) : super(MovieSearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      if (query.isEmpty) {
        emit(MovieSearchEmpty());
        return;
      }

      emit(MovieSearchLoading());
      final result = await searchMovies.execute(query);

      result.fold(
        (failure) => emit(MovieSearchError(failure.message)),
        (data) => emit(MovieSearchHasData(data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
