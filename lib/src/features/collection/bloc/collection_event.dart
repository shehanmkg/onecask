part of 'collection_bloc.dart';

abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object> get props => [];
}

// Event to trigger loading the collection items initially
class LoadCollection extends CollectionEvent {}

// Event to trigger refreshing the collection items (e.g., pull-to-refresh)
class RefreshCollection extends CollectionEvent {}

// // Optional: Event if filtering/searching is added later
// class FilterCollection extends CollectionEvent {
//   final String query;
//   const FilterCollection(this.query);
//   @override List<Object> get props => [query];
// }