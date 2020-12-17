import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class SearchAccountStates extends Equatable {
  const SearchAccountStates();

  @override
  List<Object> get props => [];
}

class SearchAccountEmpty extends SearchAccountStates {}

class SearchAccountInitial extends SearchAccountStates {}

class SearchAccountFailure extends SearchAccountStates {}

class SearchAccountSuccess extends SearchAccountStates {
  final List<Account> accounts;
  final bool hasReachedMax;
  final String searchedKeyword;

  const SearchAccountSuccess({
    this.accounts,
    this.hasReachedMax,
    this.searchedKeyword,
  });

  // SearchAccountSuccess copyWith({List<Account> accounts, bool hasReachedMax}) {
  //   return SearchAccountSuccess(
  //     accounts: accounts ?? this.accounts,
  //     hasReachedMax: hasReachedMax ?? this.hasReachedMax,
  //     searchedKeyword: searchedKeyword ?? this.searchedKeyword,
  //   );
  // }

  @override
  List<Object> get props => [accounts, hasReachedMax, searchedKeyword];

  @override
  String toString() =>
      'SearchAccountSuccess { posts: ${accounts.length}, hasReachedMax: $hasReachedMax }';
}
