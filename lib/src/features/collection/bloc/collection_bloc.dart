library collection_bloc;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/collection_repository.dart'; // Import the repository
import '../../../models/collection_item.dart'; // Import the model

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

  Future<void> _onLoadCollection(
      LoadCollection event, Emitter<CollectionState> emit) async {
    // Avoid reloading if already loaded, unless forced (handled by RefreshCollection)
    if (state is CollectionLoading || state is CollectionLoaded) return;

    emit(CollectionLoading());
    try {
      final items = await _collectionRepository.getCollectionItems();
      emit(CollectionLoaded(items));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onRefreshCollection(
      RefreshCollection event, Emitter<CollectionState> emit) async {
     // Always show loading indicator during refresh
     emit(CollectionLoading());
     try {
       // Use the repository's refresh logic (which likely calls getCollectionItems again)
       final items = await _collectionRepository.refreshCollectionItems();
       emit(CollectionLoaded(items));
     } catch (e) {
       emit(CollectionError(e.toString()));
       // Optional: If refresh fails, could emit previous state if available?
       // Example: if (state is CollectionLoaded) emit(state); else emit(CollectionError...);
     }
  }
}