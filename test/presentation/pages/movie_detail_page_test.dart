import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUpAll(() {
    setTestEnvironment(true);
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
  });

  tearDownAll(() {
    setTestEnvironment(false);
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

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
    genreIds: [1],
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

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(
        () => mockMovieDetailBloc.state,
      ).thenReturn(MovieDetailHasData(tMovieDetail, [tMovie]));
      when(
        () => mockWatchlistMovieBloc.state,
      ).thenReturn(WatchlistMovieStatusLoaded(false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(
        () => mockMovieDetailBloc.state,
      ).thenReturn(MovieDetailHasData(tMovieDetail, [tMovie]));
      when(
        () => mockWatchlistMovieBloc.state,
      ).thenReturn(WatchlistMovieStatusLoaded(true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(
        () => mockMovieDetailBloc.state,
      ).thenReturn(MovieDetailHasData(tMovieDetail, [tMovie]));
      when(
        () => mockWatchlistMovieBloc.state,
      ).thenReturn(WatchlistMovieStatusLoaded(false));
      whenListen(
        mockWatchlistMovieBloc,
        Stream.fromIterable([
          WatchlistMovieSuccess('Added to Watchlist'),
          WatchlistMovieStatusLoaded(true),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );
}
