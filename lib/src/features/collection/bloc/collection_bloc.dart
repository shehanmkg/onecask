library collection_bloc;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/collection_repository.dart';
import '../../../models/whiskey.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository _collectionRepository;

  CollectionBloc({required CollectionRepository collectionRepository})
      : _collectionRepository = collectionRepository,
        super(CollectionInitial()) {
    on<LoadCollection>(_onLoadCollection);
    on<RefreshCollection>(_onRefreshCollection);

    // Trigger initial load
    add(LoadCollection());
  }

  Future<void> _onLoadCollection(LoadCollection event, Emitter<CollectionState> emit) async {
    // Avoid reloading if already loaded, unless forced (handled by RefreshCollection)
    if (state is CollectionLoading) return;

    emit(CollectionLoading());
    try {
      final whiskeys = await _collectionRepository.getWhiskeys();
      emit(CollectionLoaded(whiskeys));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onRefreshCollection(RefreshCollection event, Emitter<CollectionState> emit) async {
    // Always show loading indicator during refresh
    emit(CollectionLoading());
    try {
      // Use the repository's refresh logic
      final whiskeys = await _collectionRepository.refreshWhiskeys();
      emit(CollectionLoaded(whiskeys));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }
}
