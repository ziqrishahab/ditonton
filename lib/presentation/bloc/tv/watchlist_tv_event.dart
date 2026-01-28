part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTv extends WatchlistTvEvent {}

class LoadWatchlistTvStatus extends WatchlistTvEvent {
  final int id;

  const LoadWatchlistTvStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddTvToWatchlist extends WatchlistTvEvent {
  final TvDetail tv;

  const AddTvToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTvFromWatchlist extends WatchlistTvEvent {
  final TvDetail tv;

  const RemoveTvFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
