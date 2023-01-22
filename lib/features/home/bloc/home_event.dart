part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.initialize() = Initialize;
  const factory HomeEvent.sort(String query) = Sort;
  const factory HomeEvent.loadMore() = LoadMore;
  const factory HomeEvent.search(String query) = Search;
}
