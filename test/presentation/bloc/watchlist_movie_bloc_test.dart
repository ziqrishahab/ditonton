import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('Get Watchlist Movies', () {
    test('initial state should be empty', () {
      expect(bloc.state, WatchlistMovieEmpty());
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieError('Database Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  group('Watchlist Status', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistStatus] with true when movie is in watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(1)),
      expect: () => [WatchlistMovieStatusLoaded(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(1));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistStatus] with false when movie is not in watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(1)),
      expect: () => [WatchlistMovieStatusLoaded(false)],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(1));
      },
    );
  });

  group('Add Watchlist', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistMessage, WatchlistStatus] when add watchlist is successful',
      build: () {
        when(
          mockSaveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Right('Added to Watchlist'));
        when(
          mockGetWatchListStatus.execute(tMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
      expect: () => [
        WatchlistMovieSuccess('Added to Watchlist'),
        WatchlistMovieStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistError] when add watchlist is unsuccessful',
      build: () {
        when(
          mockSaveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(
          mockGetWatchListStatus.execute(tMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
      expect: () => [
        WatchlistMovieError('Database Failure'),
        WatchlistMovieStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
      },
    );
  });

  group('Remove Watchlist', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistMessage, WatchlistStatus] when remove watchlist is successful',
      build: () {
        when(
          mockRemoveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Right('Removed from Watchlist'));
        when(
          mockGetWatchListStatus.execute(tMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
      expect: () => [
        WatchlistMovieSuccess('Removed from Watchlist'),
        WatchlistMovieStatusLoaded(false),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchListStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistError] when remove watchlist is unsuccessful',
      build: () {
        when(
          mockRemoveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(
          mockGetWatchListStatus.execute(tMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
      expect: () => [
        WatchlistMovieError('Database Failure'),
        WatchlistMovieStatusLoaded(true),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
      },
    );
  });
}
