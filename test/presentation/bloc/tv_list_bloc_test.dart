import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTv])
void main() {
  late OnTheAirTvBloc bloc;
  late MockGetOnTheAirTv mockGetOnTheAirTv;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    bloc = OnTheAirTvBloc(mockGetOnTheAirTv);
  });

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
    expect(bloc.state, TvListEmpty());
  });

  blocTest<OnTheAirTvBloc, TvListState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTv()),
    expect: () => [TvListLoading(), TvListHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );

  blocTest<OnTheAirTvBloc, TvListState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTv()),
    expect: () => [TvListLoading(), TvListError('Server Failure')],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );
}
