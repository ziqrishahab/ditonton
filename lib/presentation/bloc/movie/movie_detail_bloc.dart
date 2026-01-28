import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationsResult = await getMovieRecommendations.execute(
        event.id,
      );

      detailResult.fold((failure) => emit(MovieDetailError(failure.message)), (
        movie,
      ) {
        recommendationsResult.fold(
          (failure) => emit(MovieDetailHasData(movie, const [])),
          (recommendations) => emit(MovieDetailHasData(movie, recommendations)),
        );
      });
    });
  }
}
