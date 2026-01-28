import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistMovieBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (movies) => emit(WatchlistMovieHasData(movies)),
      );
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(WatchlistMovieStatusLoaded(result));
    });

    on<AddMovieToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (success) => emit(WatchlistMovieSuccess(watchlistAddSuccessMessage)),
      );
      add(LoadWatchlistStatus(event.movie.id));
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (success) => emit(WatchlistMovieSuccess(watchlistRemoveSuccessMessage)),
      );
      add(LoadWatchlistStatus(event.movie.id));
    });
  }
}
