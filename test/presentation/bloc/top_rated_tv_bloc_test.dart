import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late TopRatedTvBloc bloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    bloc = TopRatedTvBloc(mockGetTopRatedTv);
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
    expect(bloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [TopRatedTvLoading(), TopRatedTvHasData(tTvList)],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [TopRatedTvLoading(), TopRatedTvError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );
}
