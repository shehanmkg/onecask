part of 'collection_bloc.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<Whiskey> whiskeys;

  const CollectionLoaded(this.whiskeys);

  @override
  List<Object> get props => [whiskeys];
}

class CollectionError extends CollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object> get props => [message];
}
