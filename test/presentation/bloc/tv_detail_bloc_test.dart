import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail, GetTvRecommendations])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  const tId = 1;

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

  test('initial state should be empty', () {
    expect(bloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [TvDetailLoading(), TvDetailHasData(tTvDetail, tTvList)],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get tv detail is unsuccessful',
    build: () {
      when(
        mockGetTvDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTvRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [TvDetailLoading(), TvDetailError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );
}
