part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {}

class LoadWatchlistStatus extends WatchlistMovieEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
