import 'package:cleanrchitecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTriviaModel] witch was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  cacheNumberTrivia(NumberTriviaModel numberTriviaToCache);
}
