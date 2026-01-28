import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      context.read<WatchlistTvBloc>().add(LoadWatchlistTvStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TvDetailHasData) {
            final tv = state.tv;
            return SafeArea(child: DetailContent(tv, state.recommendations));
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;

  DetailContent(this.tv, this.recommendations);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<WatchlistTvBloc, WatchlistTvState>(
      listenWhen: (previous, current) =>
          current is WatchlistTvSuccess || current is WatchlistTvError,
      listener: (context, state) {
        if (state is WatchlistTvSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is WatchlistTvError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(state.message));
            },
          );
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
            width: screenWidth,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tv.name, style: kHeading5),
                              BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
                                buildWhen: (previous, current) =>
                                    current is WatchlistTvStatusLoaded,
                                builder: (context, state) {
                                  final isAddedWatchlist =
                                      state is WatchlistTvStatusLoaded
                                      ? state.isAddedToWatchlist
                                      : false;
                                  return FilledButton(
                                    onPressed: () async {
                                      if (!isAddedWatchlist) {
                                        context.read<WatchlistTvBloc>().add(
                                          AddTvToWatchlist(tv),
                                        );
                                      } else {
                                        context.read<WatchlistTvBloc>().add(
                                          RemoveTvFromWatchlist(tv),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        isAddedWatchlist
                                            ? Icon(Icons.check)
                                            : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Text(_showGenres(tv.genres)),
                              Text(
                                '${tv.numberOfSeasons} Seasons - ${tv.numberOfEpisodes} Episodes',
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: tv.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) =>
                                        Icon(Icons.star, color: kMikadoYellow),
                                    itemSize: 24,
                                  ),
                                  Text('${tv.voteAverage}'),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text('Overview', style: kHeading6),
                              Text(tv.overview),
                              SizedBox(height: 16),
                              Text('Recommendations', style: kHeading6),
                              Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final tv = recommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TvDetailPage.ROUTE_NAME,
                                            arguments: tv.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                            placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: recommendations.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
