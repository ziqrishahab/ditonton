import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistTvBloc({
    required this.getWatchlistTv,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlistTv.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (tvs) => emit(WatchlistTvHasData(tvs)),
      );
    });

    on<LoadWatchlistTvStatus>((event, emit) async {
      final result = await getWatchListStatusTv.execute(event.id);
      emit(WatchlistTvStatusLoaded(result));
    });

    on<AddTvToWatchlist>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tv);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (success) => emit(WatchlistTvSuccess(watchlistAddSuccessMessage)),
      );
      add(LoadWatchlistTvStatus(event.tv.id));
    });

    on<RemoveTvFromWatchlist>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tv);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (success) => emit(WatchlistTvSuccess(watchlistRemoveSuccessMessage)),
      );
      add(LoadWatchlistTvStatus(event.tv.id));
    });
  }
}
