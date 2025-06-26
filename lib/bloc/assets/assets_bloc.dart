import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/asset.dart';
import '../../models/user.dart';
import '../../data/mock_data.dart';

// Events
abstract class AssetsEvent extends Equatable {
  const AssetsEvent();

  @override
  List<Object> get props => [];
}

class LoadAssets extends AssetsEvent {}

class LoadActivities extends AssetsEvent {}

class ToggleBalanceVisibility extends AssetsEvent {}

class RefreshAssets extends AssetsEvent {}

class SwitchTab extends AssetsEvent {
  final int tabIndex; // 0: 持有代币, 1: 活动

  const SwitchTab(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class UpdateTimePeriod extends AssetsEvent {
  final String period; // '7d', '30d', '1y'

  const UpdateTimePeriod(this.period);

  @override
  List<Object> get props => [period];
}

// States
abstract class AssetsState extends Equatable {
  const AssetsState();

  @override
  List<Object> get props => [];
}

class AssetsInitial extends AssetsState {}

class AssetsLoading extends AssetsState {}

class AssetsLoaded extends AssetsState {
  final User user;
  final List<Asset> assets;
  final List<Activity> activities;
  final bool isBalanceVisible;
  final int selectedTabIndex;
  final String selectedPeriod;
  final double totalPnl;
  final double totalUnrealizedPnl;
  final double totalValue;

  const AssetsLoaded({
    required this.user,
    required this.assets,
    required this.activities,
    this.isBalanceVisible = true,
    this.selectedTabIndex = 0,
    this.selectedPeriod = '7d',
    required this.totalPnl,
    required this.totalUnrealizedPnl,
    required this.totalValue,
  });

  @override
  List<Object> get props => [
        user,
        assets,
        activities,
        isBalanceVisible,
        selectedTabIndex,
        selectedPeriod,
        totalPnl,
        totalUnrealizedPnl,
        totalValue,
      ];

  AssetsLoaded copyWith({
    User? user,
    List<Asset>? assets,
    List<Activity>? activities,
    bool? isBalanceVisible,
    int? selectedTabIndex,
    String? selectedPeriod,
    double? totalPnl,
    double? totalUnrealizedPnl,
    double? totalValue,
  }) {
    return AssetsLoaded(
      user: user ?? this.user,
      assets: assets ?? this.assets,
      activities: activities ?? this.activities,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      totalPnl: totalPnl ?? this.totalPnl,
      totalUnrealizedPnl: totalUnrealizedPnl ?? this.totalUnrealizedPnl,
      totalValue: totalValue ?? this.totalValue,
    );
  }
}

class AssetsError extends AssetsState {
  final String message;

  const AssetsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  AssetsBloc() : super(AssetsInitial()) {
    on<LoadAssets>(_onLoadAssets);
    on<LoadActivities>(_onLoadActivities);
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
    on<RefreshAssets>(_onRefreshAssets);
    on<SwitchTab>(_onSwitchTab);
    on<UpdateTimePeriod>(_onUpdateTimePeriod);
  }

  Future<void> _onLoadAssets(
    LoadAssets event,
    Emitter<AssetsState> emit,
  ) async {
    emit(AssetsLoading());

    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 500));

      final user = MockData.mockUser;
      final assets = MockData.mockAssets;
      final activities = MockData.mockActivities;

      // 计算总资产数据
      final totalValue = assets.fold(0.0, (sum, asset) => sum + asset.value);
      final totalPnl = assets.fold(0.0, (sum, asset) => sum + asset.pnl);
      final totalUnrealizedPnl = assets.fold(
          0.0,
          (sum, asset) =>
              sum + (asset.pnl > 0 ? asset.pnl * 0.7 : asset.pnl * 0.8));

      emit(AssetsLoaded(
        user: user,
        assets: assets,
        activities: activities,
        totalPnl: totalPnl,
        totalUnrealizedPnl: totalUnrealizedPnl,
        totalValue: totalValue,
      ));
    } catch (e) {
      emit(AssetsError('加载资产数据失败: $e'));
    }
  }

  Future<void> _onLoadActivities(
    LoadActivities event,
    Emitter<AssetsState> emit,
  ) async {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;

      try {
        await Future.delayed(const Duration(milliseconds: 300));

        final activities = MockData.mockActivities;
        emit(currentState.copyWith(activities: activities));
      } catch (e) {
        emit(AssetsError('加载活动数据失败: $e'));
      }
    }
  }

  Future<void> _onToggleBalanceVisibility(
    ToggleBalanceVisibility event,
    Emitter<AssetsState> emit,
  ) async {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;

      final updatedUser = User(
        id: currentState.user.id,
        email: currentState.user.email,
        walletAddress: currentState.user.walletAddress,
        followers: currentState.user.followers,
        solBalance: currentState.user.solBalance,
        isBalanceVisible: !currentState.user.isBalanceVisible,
      );

      emit(currentState.copyWith(
        user: updatedUser,
        isBalanceVisible: !currentState.isBalanceVisible,
      ));
    }
  }

  Future<void> _onRefreshAssets(
    RefreshAssets event,
    Emitter<AssetsState> emit,
  ) async {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;

      try {
        // 模拟刷新延迟
        await Future.delayed(const Duration(milliseconds: 800));

        // 重新加载数据
        final assets = MockData.mockAssets;
        final activities = MockData.mockActivities;

        // 重新计算总资产数据
        final totalValue = assets.fold(0.0, (sum, asset) => sum + asset.value);
        final totalPnl = assets.fold(0.0, (sum, asset) => sum + asset.pnl);
        final totalUnrealizedPnl = assets.fold(
            0.0,
            (sum, asset) =>
                sum + (asset.pnl > 0 ? asset.pnl * 0.7 : asset.pnl * 0.8));

        emit(currentState.copyWith(
          assets: assets,
          activities: activities,
          totalPnl: totalPnl,
          totalUnrealizedPnl: totalUnrealizedPnl,
          totalValue: totalValue,
        ));
      } catch (e) {
        emit(AssetsError('刷新资产数据失败: $e'));
      }
    }
  }

  Future<void> _onSwitchTab(
    SwitchTab event,
    Emitter<AssetsState> emit,
  ) async {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;
      emit(currentState.copyWith(selectedTabIndex: event.tabIndex));
    }
  }

  Future<void> _onUpdateTimePeriod(
    UpdateTimePeriod event,
    Emitter<AssetsState> emit,
  ) async {
    if (state is AssetsLoaded) {
      final currentState = state as AssetsLoaded;
      emit(currentState.copyWith(selectedPeriod: event.period));
    }
  }
}
