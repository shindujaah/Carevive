import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvent {
  final String category;

  FetchNews(this.category);

  @override
  List<Object> get props => [category];
}
