# <p align="center"> Clean architecture and test driven development</p>
#### <p align="center"> A Course of [Reso Coder](https://www.youtube.com/c/ResoCoder) </p>

---

if you are interested in watching this course, please check this [playlist](https://www.youtube.com/watch?v=KjE2IDphA_U&list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech&index=1&ab_channel=ResoCoder).  

as the course was recorded in 2019 and at that time dart did not have **null-safety** some things you will need to do in a different way if you are using the **Dart** version ```>=2.12``` ```&&``` **Flutter** version ```>= 2.0```.

For example, when making mocks for **unit tests** you will need to read the documentations below for a better understanding of what has changed:  
[Mockito null-safety](https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md)   
[Dart null-safety](https://dart.dev/null-safety)  
[Flutter unit tests](https://docs.flutter.dev/cookbook/testing/unit/mocking)

_what's changed in a **nutshell**_

creating a mock **without** null-safety  
```class MockClassExample extends Mock implements ClassExample {} ```

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

---

<p align="center">
  <img src="https://github.com/gcoutinho1/cleanarchitecture_tdd/blob/main/imgs/cleanarchitecture.jpg">
</p>

<p align="center">
  <img src="https://github.com/gcoutinho1/cleanarchitecture_tdd/blob/main/imgs/diagrama.png">
</p>