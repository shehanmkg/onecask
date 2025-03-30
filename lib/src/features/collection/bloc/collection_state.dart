part of 'collection_bloc.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

// Initial state, before any loading attempt
class CollectionInitial extends CollectionState {}

// State while items are being loaded or refreshed
class CollectionLoading extends CollectionState {}

// State when items have been successfully loaded
class CollectionLoaded extends CollectionState {
  final List<Whiskey> whiskeys;

  const CollectionLoaded(this.whiskeys);

  @override
  List<Object> get props => [whiskeys];
}

// State when an error occurs during loading or refreshing
class CollectionError extends CollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object> get props => [message];
}
