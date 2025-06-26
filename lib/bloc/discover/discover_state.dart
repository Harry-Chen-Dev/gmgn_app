import 'package:equatable/equatable.dart';
import '../../models/token.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  final List<Token> tokens;
  final String currentTab;
  final String currentFilter;
  final bool isRefreshing;

  const DiscoverLoaded({
    required this.tokens,
    this.currentTab = 'watchlist',
    this.currentFilter = 'new_created',
    this.isRefreshing = false,
  });

  DiscoverLoaded copyWith({
    List<Token>? tokens,
    String? currentTab,
    String? currentFilter,
    bool? isRefreshing,
  }) {
    return DiscoverLoaded(
      tokens: tokens ?? this.tokens,
      currentTab: currentTab ?? this.currentTab,
      currentFilter: currentFilter ?? this.currentFilter,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [tokens, currentTab, currentFilter, isRefreshing];
}

class DiscoverError extends DiscoverState {
  final String message;

  const DiscoverError({required this.message});

  @override
  List<Object?> get props => [message];
}
