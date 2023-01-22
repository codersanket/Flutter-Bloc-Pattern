part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<String> categories,
    @Default([]) List<ProductModel> products,
    @Default(false) bool isLoadingMore,
    @Default([]) List<ProductModel> searchList,
    @Default('') String query,
  }) = HomeStateView;

  const factory HomeState.loading() = _Loading;
}
