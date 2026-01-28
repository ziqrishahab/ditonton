import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "/muth4OYamXf41G2evdrLEg8d3om.jpg",
    genreIds: [18, 10765],
    id: 1399,
    originalName: "Game of Thrones",
    overview:
        "Seven noble families fight for control of the mythical land of Westeros.",
    popularity: 369.594,
    posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
    firstAirDate: "2011-04-17",
    name: "Game of Thrones",
    voteAverage: 8.3,
    voteCount: 11504,
  );
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/on_the_air_tv.json'),
      );
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/muth4OYamXf41G2evdrLEg8d3om.jpg",
            "first_air_date": "2011-04-17",
            "genre_ids": [18, 10765],
            "id": 1399,
            "name": "Game of Thrones",
            "original_name": "Game of Thrones",
            "overview":
                "Seven noble families fight for control of the mythical land of Westeros.",
            "popularity": 369.594,
            "poster_path": "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
            "vote_average": 8.3,
            "vote_count": 11504,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
