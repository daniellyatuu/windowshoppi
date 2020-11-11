import 'package:bloc/bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:meta/meta.dart';

class CountryBloc extends Bloc<CountryEvents, CountryStates> {
  final CountryRepository countryRepository;
  CountryBloc({@required this.countryRepository})
      : assert(countryRepository != null),
        super(CountryEmpty());

  @override
  Stream<CountryStates> mapEventToState(
    CountryEvents event,
  ) async* {
    print('step 1 : bloc');
    if (event is FetchCountry) {
      yield CountryLoading();
      try {
        final List<Country> country = await countryRepository.getCountry();
        yield CountryLoaded(country: country);
      } catch (error) {
        print(error);
        yield CountryError();
      }
    }
    // } else if (event is RefreshPosts) {
    //   try {
    //     if (event.keyword != '') {
    //       final List<Post> post = await postsRepository.getPosts(event.keyword);
    //       yield PostLoaded(post: post);
    //     } else {
    //       yield PostEmpty();
    //     }
    //   } catch (error) {
    //     print("Error" + error);
    //     yield state;
    //   }
    // } else if (event is ResetPosts) {
    //   print('empty');
    //   yield PostEmpty();
    // }
  }
}