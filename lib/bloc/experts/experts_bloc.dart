import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/expert.dart';
import '../../data/mock_data.dart';

// Events
abstract class ExpertsEvent extends Equatable {
  const ExpertsEvent();

  @override
  List<Object> get props => [];
}

class LoadExperts extends ExpertsEvent {}

class LoadWalletFollows extends ExpertsEvent {}

class ToggleFollow extends ExpertsEvent {
  final String expertId;

  const ToggleFollow(this.expertId);

  @override
  List<Object> get props => [expertId];
}

class FilterExpertsByType extends ExpertsEvent {
  final String
      type; // 'all', 'pump_smart', 'smart_money', 'new_wallet', 'kol_vc'

  const FilterExpertsByType(this.type);

  @override
  List<Object> get props => [type];
}

// States
abstract class ExpertsState extends Equatable {
  const ExpertsState();

  @override
  List<Object> get props => [];
}

class ExpertsInitial extends ExpertsState {}

class ExpertsLoading extends ExpertsState {}

class ExpertsLoaded extends ExpertsState {
  final List<Expert> experts;
  final List<Expert> walletFollows;
  final String selectedFilter;

  const ExpertsLoaded({
    required this.experts,
    required this.walletFollows,
    this.selectedFilter = 'all',
  });

  @override
  List<Object> get props => [experts, walletFollows, selectedFilter];

  ExpertsLoaded copyWith({
    List<Expert>? experts,
    List<Expert>? walletFollows,
    String? selectedFilter,
  }) {
    return ExpertsLoaded(
      experts: experts ?? this.experts,
      walletFollows: walletFollows ?? this.walletFollows,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class ExpertsError extends ExpertsState {
  final String message;

  const ExpertsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ExpertsBloc extends Bloc<ExpertsEvent, ExpertsState> {
  ExpertsBloc() : super(ExpertsInitial()) {
    on<LoadExperts>(_onLoadExperts);
    on<LoadWalletFollows>(_onLoadWalletFollows);
    on<ToggleFollow>(_onToggleFollow);
    on<FilterExpertsByType>(_onFilterExpertsByType);
  }

  Future<void> _onLoadExperts(
    LoadExperts event,
    Emitter<ExpertsState> emit,
  ) async {
    emit(ExpertsLoading());

    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 500));

      final experts = MockData.mockExperts;
      final walletFollows = MockData.mockWalletFollows;

      emit(ExpertsLoaded(
        experts: experts,
        walletFollows: walletFollows,
      ));
    } catch (e) {
      emit(ExpertsError('加载专家数据失败: $e'));
    }
  }

  Future<void> _onLoadWalletFollows(
    LoadWalletFollows event,
    Emitter<ExpertsState> emit,
  ) async {
    if (state is ExpertsLoaded) {
      final currentState = state as ExpertsLoaded;
      emit(ExpertsLoading());

      try {
        await Future.delayed(const Duration(milliseconds: 300));

        emit(currentState.copyWith(
          walletFollows: MockData.mockWalletFollows,
        ));
      } catch (e) {
        emit(ExpertsError('加载钱包跟单数据失败: $e'));
      }
    }
  }

  Future<void> _onToggleFollow(
    ToggleFollow event,
    Emitter<ExpertsState> emit,
  ) async {
    if (state is ExpertsLoaded) {
      final currentState = state as ExpertsLoaded;

      // 更新专家关注状态
      final updatedExperts = currentState.experts.map((expert) {
        if (expert.id == event.expertId) {
          return Expert(
            id: expert.id,
            walletAddress: expert.walletAddress,
            displayName: expert.displayName,
            avatarUrl: expert.avatarUrl,
            rank: expert.rank,
            solBalance: expert.solBalance,
            pnl: expert.pnl,
            pnlPercentage: expert.pnlPercentage,
            followers: expert.followers,
            totalTrades: expert.totalTrades,
            winRate: expert.winRate,
            lastActivity: expert.lastActivity,
            isFollowing: !expert.isFollowing,
            type: expert.type,
          );
        }
        return expert;
      }).toList();

      emit(currentState.copyWith(experts: updatedExperts));
    }
  }

  Future<void> _onFilterExpertsByType(
    FilterExpertsByType event,
    Emitter<ExpertsState> emit,
  ) async {
    if (state is ExpertsLoaded) {
      final currentState = state as ExpertsLoaded;

      List<Expert> filteredExperts;
      if (event.type == 'all') {
        filteredExperts = MockData.mockExperts;
      } else {
        filteredExperts = MockData.mockExperts
            .where((expert) => expert.type == event.type)
            .toList();
      }

      emit(currentState.copyWith(
        experts: filteredExperts,
        selectedFilter: event.type,
      ));
    }
  }
}
