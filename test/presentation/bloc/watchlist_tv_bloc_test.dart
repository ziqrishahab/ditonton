import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTv,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = WatchlistTvBloc(
      getWatchlistTv: mockGetWatchlistTv,
      getWatchListStatusTv: mockGetWatchListStatusTv,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  final tTvDetail = TvDetail(
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
  );

  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTv];

  group('Get Watchlist Tv', () {
    test('initial state should be empty', () {
      expect(bloc.state, WatchlistTvEmpty());
    });

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(
          mockGetWatchlistTv.execute(),
        ).thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [WatchlistTvLoading(), WatchlistTvHasData(tTvList)],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetWatchlistTv.execute(),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );
  });

  group('Watchlist Status', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistStatus] with true when tv is in watchlist',
      build: () {
        when(mockGetWatchListStatusTv.execute(1)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvStatus(1)),
      expect: () => [WatchlistTvStatusLoaded(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(1));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistStatus] with false when tv is not in watchlist',
      build: () {
        when(
          mockGetWatchListStatusTv.execute(1),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvStatus(1)),
      expect: () => [WatchlistTvStatusLoaded(false)],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(1));
      },
    );
  });

  group('Add Watchlist', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistMessage, WatchlistStatus] when add watchlist is successful',
      build: () {
        when(
          mockSaveWatchlistTv.execute(tTvDetail),
        ).thenAnswer((_) async => Right('Added to Watchlist'));
        when(
          mockGetWatchListStatusTv.execute(tTvDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(tTvDetail)),
      expect: () => [
        WatchlistTvSuccess('Added to Watchlist'),
        WatchlistTvStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchListStatusTv.execute(tTvDetail.id));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistError] when add watchlist is unsuccessful',
      build: () {
        when(
          mockSaveWatchlistTv.execute(tTvDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(
          mockGetWatchListStatusTv.execute(tTvDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(tTvDetail)),
      expect: () => [
        WatchlistTvError('Database Failure'),
        WatchlistTvStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(tTvDetail));
      },
    );
  });

  group('Remove Watchlist', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistMessage, WatchlistStatus] when remove watchlist is successful',
      build: () {
        when(
          mockRemoveWatchlistTv.execute(tTvDetail),
        ).thenAnswer((_) async => Right('Removed from Watchlist'));
        when(
          mockGetWatchListStatusTv.execute(tTvDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(tTvDetail)),
      expect: () => [
        WatchlistTvSuccess('Removed from Watchlist'),
        WatchlistTvStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
        verify(mockGetWatchListStatusTv.execute(tTvDetail.id));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistError] when remove watchlist is unsuccessful',
      build: () {
        when(
          mockRemoveWatchlistTv.execute(tTvDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(
          mockGetWatchListStatusTv.execute(tTvDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(tTvDetail)),
      expect: () => [
        WatchlistTvError('Database Failure'),
        WatchlistTvStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
      },
    );
  });
}
