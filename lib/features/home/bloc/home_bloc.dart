import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_box/repositories/home_repository.dart';
import 'package:infinity_box/shared/helpers/model_helper.dart';
import 'package:rxdart/rxdart.dart';
import '../../../model/product_model.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final ModalHelper _helper;
  bool _isReachedToEnd = false;
  int _limit = 5;

  List<ProductModel> _products = [];

  HomeStateView get _state => state.mapOrNull((value) => value)!;

  HomeBloc(
    this._helper,
    this._homeRepository,
  ) : super(const HomeState.loading()) {
    on<Initialize>(_initialize);
    on<LoadMore>(_loadMore);
    on<Sort>(_sort);
    on<Search>(
      _search,
      transformer: (events, mapper) => events
          .debounceTime(
            const Duration(milliseconds: 300),
          )
          .asyncExpand(mapper),
    );
  }

  Future<void> _initialize(
    Initialize initialize,
    Emitter<HomeState> emit,
  ) async {
    final resp = await Future.wait(
      [_homeRepository.getCategories(), _homeRepository.getProducts(_limit)],
    );

    if (resp.first.isSuccess && resp.last.isSuccess) {
      _products = resp.last.success as List<ProductModel>;
      emit(
        HomeState(
          categories: resp.first.success as List<String>,
          products: _products,
        ),
      );
    } else {
      if (resp.first.isFailed) {
        _helper.showSnackBar(resp.first.failure.reason);
      } else {
        _helper.showSnackBar(resp.last.failure.reason);
      }
    }
  }

  Future<void> _loadMore(LoadMore loadMore, Emitter<HomeState> emit) async {
    if (_isReachedToEnd) return;

    if (_state.isLoadingMore) return;

    emit(_state.copyWith(isLoadingMore: true));
    _limit += 5;

    final resp = await _homeRepository.getProducts(_limit);
    if (resp.isSuccess) {
      if (_limit > resp.success.length) {
        _helper.showSnackBar('You have reached to end');
        _isReachedToEnd = true;
        emit(_state.copyWith(isLoadingMore: false));

        return;
      }
      _products = resp.success;

      emit(
        _state.copyWith(
          isLoadingMore: false,
          products: _state.query.isNotEmpty
              ? [..._getSortedList(_state.query)]
              : [...resp.success],
        ),
      );
    } else {
      emit(_state.copyWith(isLoadingMore: false));
      _helper.showSnackBar(resp.failure.reason);
    }
  }

  Future<void> _sort(Sort sort, Emitter<HomeState> emit) async {
    final mainState = state.mapOrNull((value) => value)!;
    final query = sort.query;
    if (query == mainState.query) {
      emit(
        mainState.copyWith(products: [..._products], query: ''),
      );

      return;
    }

    emit(
      mainState.copyWith(query: query, products: [..._getSortedList(query)]),
    );
  }

  Future<void> _search(Search search, Emitter<HomeState> emit) async {
    final query = search.query;
    if (query.isEmpty) {
      emit(
        _state.copyWith(
          searchList: _products,
        ),
      );

      return;
    }

    emit(
      _state.copyWith(
        searchList: _searchQuery(query),
      ),
    );
  }

  List<ProductModel> _getSortedList(String query) =>
      _products.where((element) => element.category == query).toList();

  List<ProductModel> _searchQuery(String query) => _products
      .where((element) =>
          element.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
