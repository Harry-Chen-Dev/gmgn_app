import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object> get props => [];
}

class DiscoverLoadTokens extends DiscoverEvent {
  const DiscoverLoadTokens();
}

class DiscoverRefreshTokens extends DiscoverEvent {
  const DiscoverRefreshTokens();
}

class DiscoverFilterChanged extends DiscoverEvent {
  final String filter; // 'new_created', 'nearly_full', 'surge', 'listed'

  const DiscoverFilterChanged({required this.filter});

  @override
  List<Object> get props => [filter];
}

class DiscoverTabChanged extends DiscoverEvent {
  final String tab; // 'watchlist', 'records', 'new_coins', 'hot', 'monitor'

  const DiscoverTabChanged({required this.tab});

  @override
  List<Object> get props => [tab];
}
