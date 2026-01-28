import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/tv/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchBloc bloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    bloc = TvSearchBloc(mockSearchTv);
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
  const tQuery = 'game of thrones';

  test('initial state should be empty', () {
    expect(bloc.state, TvSearchEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [TvSearchLoading(), TvSearchHasData(tTvList)],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [TvSearchLoading(), TvSearchError('Server Failure')],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );
}
