import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  TvDetailBloc({required this.getTvDetail, required this.getTvRecommendations})
    : super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      emit(TvDetailLoading());

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationsResult = await getTvRecommendations.execute(
        event.id,
      );

      detailResult.fold((failure) => emit(TvDetailError(failure.message)), (
        tv,
      ) {
        recommendationsResult.fold(
          (failure) => emit(TvDetailHasData(tv, const [])),
          (recommendations) => emit(TvDetailHasData(tv, recommendations)),
        );
      });
    });
  }
}
