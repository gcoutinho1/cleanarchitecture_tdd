![Dart Version](https://img.shields.io/static/v1?label=Dart&message=2.16.2&color=00579d)
![Flutter Version](https://img.shields.io/static/v1?label=Flutter&message=2.10.4&color=42a5f5)
# <p align="center"> Clean architecture and test driven development</p>
#### <p align="center"> A Course of [Reso Coder](https://www.youtube.com/c/ResoCoder) </p>

---

if you are interested in learning clean architecture and TDD, please check this [playlist](https://www.youtube.com/watch?v=KjE2IDphA_U&list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech&index=1&ab_channel=ResoCoder).  

As the course was recorded in 2019 and at that time dart did not have **null-safety**, some things you will need to do in a different way if you are using the **Dart** version ```>=2.12``` ```&&``` **Flutter** version ```>= 2.0```.

For example, when making mocks for **unit tests** you will need to read the documentations below for a better understanding of what has changed:  
[Mockito null-safety](https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md)   
[Dart null-safety](https://dart.dev/null-safety)  
[Flutter unit tests](https://docs.flutter.dev/cookbook/testing/unit/mocking)  

_What's changed in a **nutshell**_

<details>
<summary>Creating a mock without null-safety - click to see details</summary>

creating a mock **without** null-safety with mockito
```
class MockClassExample extends Mock implements ClassExample {

}
```

</details>

<details>
<summary> Creating a mock with null-safety - click to see details</summary>


- creating a mock **with** null-safety  
 - install [build_runner](https://pub.dev/packages/build_runner)  
 - create your class_example_test.dart  
 - inside class_example_test.dart write:  
```
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
@GenerateMocks([], customMocks: [
  MockSpec<ClassExampleTest>(
      as: #MockClassExampleTest, returnNullOnMissingStub: false)
])
void main() {}
```
replace **ClassExampleTest** and **MockClassExampleTest** with the object you are going to mock  
run ```flutter pub run build_runner build``` on your terminal  
this will generate the mock file of the object you want to test
</details>

After a while, I was having a lot of problems with the unit tests and I decided to change the **Mockito** for the **Mocktail**  
[MockTail Doc](https://pub.dev/packages/mocktail)  

when you are going to implement BLoC and do the unit tests, if you have some problems, I suggest replacing test() with blocTest()  
[bloc_test details](https://pub.dev/packages/bloc_test)
<details> <summary> what changes with bloc_test - click to see details </summary>

with test()
```
        test('Should emit [Error] when the input is invalid', () async {
         
         when(() => mockInputConverter.stringToUnsignedInteger(any()))
             .thenReturn(Left(InvalidInputFailure()));
         
         final expected = [
           Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
         ];
         expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        
         bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      });
```
      
      
with blocTest()
```
blocTest(
        'Should emit [Error] when the input is invalid',
        setUp: () {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));
        },
        build: () => NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        ),
        act: (NumberTriviaBloc bloc) =>
            bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
        expect: () => [
          const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
        ],
      ); 
      
```

</details>

---

<p align="center">
  <img src="https://github.com/gcoutinho1/cleanarchitecture_tdd/blob/main/imgs/cleanarchitecture.jpg">
</p>

<p align="center">
  <img src="https://github.com/gcoutinho1/cleanarchitecture_tdd/blob/main/imgs/diagrama.png">
</p>