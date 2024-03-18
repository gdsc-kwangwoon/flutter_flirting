# flutter_flirting

## Intro

플러터 플러팅 마지막 여덟 번째 세션, `Future` 세션입니다.

이번 세션에서는 Dart는 비동기 처리를 어떻게 하는지, 그리고 이를 활용할 수 있게 해주는 위젯들에 대해 알아보겠습니다.

## Future

Future 객체는 지금 당장은 처리되지 않았지만, 미래의 처리가 완료되면 데이터를 반환한다를 알려주는 객체입니다.

예로 들어 아래의 코드가 있다고 가정해봅시다.

```dart
Future<String> futureStr() async {
  print('do something');
  return Future.delayed(Duration(seconds: 2), () => 'future string');
}

void main() {
  print('start');
  print(futureStr());
}
```

실행 결과는 어떻게 될까요?

> start
> do something
> Instance of 'Future<String>'
> (2초 후 종료)

'future string' 대신 Future<String> 객체가 결과로 나왔습니다.

여기서 알 수 있는 점은 Future은 비동기 처리를 알아서 해주는 마법같은 객체가 아닌, 단순한 클래스의 인스턴스 라는 점입니다.

그렇다면 'future string'을 반환 받으려면 어떻게 해야할까요?
이를 알아보기 전에 우선 Future에 대해 좀 더 자세히 알아봅시다.

Future은 Uncompleted, Completed 상태를 갖습니다.
Future가 Uncompleted 상태라면 Future 객체는 객체의 인스턴스 자체를 반환합니다. (Future<String>)
하지만, Completed 상태라면 Future 객체의 제네릭으로 지정된 실제 데이터를 반환합니다.

즉, Future가 Completed 상태가 되기 전에 futureStr()을 출력하는 것이 아닌,
Completed 상태가 될 때 까지 기다린 후에 futureStr()을 출력해야 원하는 결과를 얻을 수 있을 것입니다.

그렇다면 어떻게 해야 Future가 Completed 상태가 될 때 까지 기다릴 수 있을까요?

그 방법은 async / await 키워드를 이용하는 것입니다.

async 키워드는 지정된 함수가 Future 객체를 반환한다는 것을 선언하는 키워드이고,
await 키워드는 async 함수 내부의 해당 키워드가 선언된 부분에서 코드 실행흐름을 중지한다는 키워드입니다.

```dart
Future<String> futureStr() async {
  print('do something');
  return Future.delayed(Duration(seconds: 2), () => 'future string');
}

void main() async {
  print('start');
  print(await futureStr());
}
```

즉, 비동기 처리를 완료해야 하기 전까지 대기해야 하는 곳 앞에 async 키워드를 달아주면 되는 것이죠.

## FutureBuilder

FutureBuilder란, 지정된 비동기 함수의 상태에 따라 위젯을 다르게 빌드해주는 위젯입니다.

FutuerBuilder의 future 파라미터에 비동기 함수를 지정해주면,
해당 비동기 함수의 상태가 변할 때 마다 builder 파라미터에 등록된 함수가 실행되는 것이죠.

builder 함수에는 snapshot 이라는 값이 넘어오는데, shapshot.hasData로 비동기 함수의 상태를 알 수 있습니다.

Uncompleted 상태라면 false 값이 들어있을 것이고, Completed 상태라면 true 값이 들어있을 것입니다.

이 것을 이용해서 로딩 위젯을 보여줄지, 데이터 위젯을 보여줄지 if 문으로 분기 처리를 할 수 있으며, 실제 데이터는 snapshot.data 에 nullable한 상태로 들어 있습니다.

## Stream

Future은 단발성 비동기 이벤트라면, Stream은 일련(Iterable)의 비동기 이벤트 입니다.

즉, iterable 하게 동작하지만, 그 과정이 연속적으로 처리되는 과정에서 비동기 이벤트가 끝날 때 마다 다음 스탭이 처리되는 것이죠!

그렇다면 여기서 의문점이 생길 수 있습니다.

> ??: 비동기 하나가 끝나면 return으로 알려줄 수 있는데, 연쇄적인 이벤트 완료는 어떻게 알려주나요? callback 함수라도 쓰나요?

Dart에서는 이를 달성하기 위해 async\* / yield 키워드를 이용합니다.

async*는 async와 마찬가지로 해당 함수가 비동기 처리를 하는 함수임을 지정하는 동시에,
함수가 종료되지 않고 계속 이벤트 완료됨을 알려줄 수 있음을 명시하는 키워드입니다.
즉, async* 가 선언된 함수는 Stream 객체를 반환해야 하고, await 키워드를 사용할 수 있습니다.

yield 키워드는 일종의 return 같은 키워드 입니다.
return은 함수를 종료시키며 데이터를 반환하지만, yield는 함수를 종료시키지 않고 데이터를 반환할 수 있습니다.

## StreamBuilder

FutureBuilder와 비슷하게 stream에 스트림 함수를 지정하면, 해당 함수에서 yield 될 때 마다(상태가 변경될 때 마다) builder 함수를 호출하는 위젯입니다.

builder 함수의 snapshot 값의 사용은 FutureBuilder와 동일합니다.

## ValueListenableBuilder

위의 Future, StreamBuilder 모두 위젯이 빌드되는 시점부터 데이터를 불러오기 시작합니다.

그렇다면, 위젯이 빌드되는 시점이 아닌, 사용자가 원하는 시점부터 데이터를 불러오는 방법은 뭐가 있을까요?

사실 Bloc과 같은 상태관리를 사용하는 것이 가장 좋지만, 간단하게 구현해보고자 ValueNotifier와 ValueListenableBuilder를 소개하겠습니다.

두 위젯은 Observer pattern으로 구현된 위젯으로,
ValueNotifier의 값이 바뀌면 notifyListeners()를 호출하는데요,
이 객체를 ValueListenableBuilder의 valueListenable 파라미터에 등록하면 notifyListeners()가 호출될 떄 마다 builder 함수가 실행이 되는 구조입니다.

즉, setState() 없이 리랜더링이 가능해집니다.

이를 활용하면 사용자가 원하는 시점에 비동기 함수를 실행하며, 로딩 상태에 따라 다른 위젯들의 리랜더링 없이 화면을 빌드할 수 있습니다.
(자세한건 코드를 참고해주세요)

## 마무리

이번 세션을 끝으로 플러터 플러팅 활동이 종료되었습니다!
함께해 주신 모든 분들 수고 많으셨고, 함깨 해주셔서 감사드립니다 (\_\_)

비록 짧은 시간동안 내용을 전달해야 했다보니 많은 내용을 소개해드릴 수는 없었습니다.
하지만, 8개의 세션의 내용만 제대로 숙지한다면 간단한 앱 빌드정도는 해볼 수 있을 것이며, 플러터 코드를 어느정도는 읽을 수 있을 것이라 생각됩니다.

사실 저도 모르는 위젯이 태반이며, 필요한 기능이 있을 때마다 검색해보며 적용해보는 과정을 거치는데요,
제대로 모르는 상태에서 시작했다보니 여러 시행착오를 겪었고, 코드도 여러번 갈아 엎었던거 같습니다..ㅎㅎ

따라서 여러분들은 좀 더 시행착오가 적도록 제가 사용하며 유용했던 라이브러리나 용어 몇 개 소개드리며 플러터 플러팅 활동 마무리 하도록 하겠습니다.

감사합니다!

-- GDSC Kwangwoon Univ. 1기 App Core 이웅재

### 상태관리

상태관리(State management)란 데이터를 관리하는 방법론으로, 여러 구성 요소(Widget, component)간 데이터 전달과 이벤트 통신을 한 곳에서 관리하는 방법을 말합니다.

앱 개발에 관심이 있으시다면 MVC, MVP, MVVM 패턴과 같은 용어를 들어보셨을 가능성이 높은데요, 이 패턴 모두 상태관리를 위한 여러 패턴 중 하나입니다.

플러터에서는 이 패턴을 사용하기 위한 상태관리 라이브러리가 있는데요, 플러터 여러 상태관리 라이브러리 중 [Bloc](https://pub.dev/packages/flutter_bloc)과 [Bloc pattern](https://with611.tistory.com/152)에 대해 소개 드립니다.

bloc을 만약 context와 의존성 없이 사용하고 싶다면 [이 글](https://wjlee611.github.io/blog/flutter/bloc_outof_context)도 읽어보시는 것을 추천 드립니다.

검색 자동완성(추천)과 같이 빈번하게 api 요청을 보내야 하는 경우에 통신량을 줄이기 위한 [bloc_concurrency](https://pub.dev/packages/bloc_concurrency) 라는 애드온(?) 라이브러리도 있으니 필요하시다면 한 번 알아보는게 좋을 거 같습니다.

### freezed

[freezed](https://pub.dev/packages/freezed)는 json의 직렬화, 역직렬화, copyWith 축약문법 자동 구현 등 모델링에 필요한 대부분의 기능을 수행 가능하게 해주는 라이브러리 입니다.

상태관리에서의 모델이나, API 응답 모델 등 대부분의 모델을 freezed를 이용하여 구축하는데요, freezed의 유일한 단점? 이라면 상속 관계를 지정할 수 없다는 것입니다.

대신 제네릭을 사용하여 상속.. 은 아니지만, 중첩되는 코드를 줄일 수 있습니다.
[여기](https://wjlee611.github.io/blog/flutter/generic_freezed)에서 freezed의 제네릭 사용법에 대해 자세히 알아보실 수 있습니다.

만약, 상속 구조를 이용하고 싶은데 json 직렬화, 역직렬화는 자체 구현하기 귀찮다 하시는 분들은 [json_serializable](https://pub.dev/packages/json_serializable)를 참고해보세요!

### Equatable

객체간 == 비교 연산이나, print를 이용한 디버깅시 Instance of ... 가 아닌 실제 데이터를 보여주는 것을 구현하는 과정은 정말이지.. 귀찮습니다.

이 모든 과정을 간단하게 수행할 수 있도록 도와주는 라이브러리가 바로 [equatable](https://pub.dev/packages/equatable)입니다.

비교 및 출력하고자 하는 객체의 멤버를 단순히 props 배열에 추가하기만 하면 됩니다!

### dio

http 통신을 체계적으로 하고싶다면 [dio](https://pub.dev/packages/dio) 라이브러리를 사용하는 것을 권장합니다.

dio는 기본적인 http 통신에서 header, query parameter, body 작성을 쉽게 할 수 있도록 도와줄 뿐 아니라,
Dio 객체마다 header를 미리 지정할 수도 있고,
interceptor 라는 일종의 미들웨어를 둬서 통신 요청, 완료, 에러시 수행할 기능을 지정할 수도 있습니다.

### 배포

본인이 만든 앱을 실제로 배포를 해보고 싶다면 [이 글](https://with611.tistory.com/158)을 참고해보시면 좋을 거 같습니다.

또한, 가끔보면 Test 어쩌구 하면서 푸쉬알림이 오는 경우가 간혹 있는데, 이런 상황을 방지하기 위해서는 빌드 환경을 dev, prod 로 분리해야 하는 경우도 있습니다.

이렇게 빌드 환경을 분리하고 싶으신 경우에는 [이 글](https://wjlee611.github.io/blog/flutter/flavorizr)을 참고해보면 좋을 거 같습니다.
