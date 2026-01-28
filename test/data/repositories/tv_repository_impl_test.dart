import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [18, 10765],
    id: 1399,
    originalName: 'Game of Thrones',
    overview:
        'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 369.594,
    posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  final tTv = Tv(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [18, 10765],
    id: 1399,
    originalName: 'Game of Thrones',
    overview:
        'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 369.594,
    posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
    firstAirDate: '2011-04-17',
    name: 'Game of Thrones',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('On The Air TV', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTv(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getOnTheAirTv();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTv()).thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTv();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTv());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTv(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTv();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTv());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular TV', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(
        mockRemoteDataSource.getPopularTv(),
      ).thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTv();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTv(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTv();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TV', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTv(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTopRatedTv();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTv()).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTv();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTv(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTv();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
      'should return TV data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenAnswer((_) async => tTvResponse);
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Right(testTvDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvRecommendations(tId),
      ).thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach TV', () {
    final tQuery = 'game of thrones';

    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTv(tQuery),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTv(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTv(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTvTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTvTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTvTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTvTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of TV', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTv(),
      ).thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
