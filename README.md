# flutter_flirting

## Intro

플러터 플러팅 다섯 번째 세션, `ListView` 세션입니다.

이번 세션에서는 Flutter의 스크롤의 근간이 되는 `Sliver`의 개념과 `Sliver`로 만들어진 `ListView`, `SliverList`에 대해 알아보고, 마지막으로 페이징을 위한 무한 스크롤을 구현하는 방법에 대해 알아보겠습니다.

## Sliver vs Widget(표준 UI 컴포넌트)

비교에 앞서 Flutter가 레이아웃을 만드는 방식을 먼저 이야기 해봅시다.

플러터에서는 랜더 객체(`Render Object`)가 있고, 대부분의 랜더 객체는 `Container`, `Sizedbox`와 같은 랜더 박스입니다.

이러한 랜더 박스는 `width`, `height`를 갖고있으며, 각각의 min, max 값을 가지기 때문에 `child 위젯`과의 관계에 의해 크기가 결정됩니다.
(관계의 의한 크기가 min, max 값 내부에 존재하지 않으면 에러가 발생하는 것이죠)

즉, 랜더 박스는 사이즈를 알려주게 되고, 레이아웃이 그 랜더 박스의 오프셋을 결정하게 됩니다.

이러한 방식은 UI를 그리는데는 좋지만, 스크롤에는 적합하지 않습니다.
스크롤에 따라 크기나 오프셋이 시시각각 변할 수 있기 때문이죠.

하지만, `Sliver` 방식은 이와 다르게 동작합니다.

`Sliver`는 `Render Sliver`의 자식 클래스로, 랜더 객체의 자식 클래스인 일반 랜더 박스와는 갖고있는 정보가 다릅니다.

`Sliver`는 width, height를 갖는 것이 아닌, [SliverConstraint](https://api.flutter.dev/flutter/rendering/SliverConstraints-class.html)(제약 조건)를 갖습니다.

`Sliver` 제약 조건은 스크롤 방향 축을 포함한 여러 정보를 담고있는데, 이런 정보가 Sliver의 스크롤 양, 다른 `Sliver`와 겹치는 양 등 여러 정보를 계산 가능하게 해줍니다.

또한, [SliverGeometry](https://api.flutter.dev/flutter/rendering/SliverGeometry-class.html)를 통해 크기와 레이아웃을 결정하게 됩니다.

즉, `Sliver`는 크기와 레이아웃(위치)를 스스로 결정할 수 없지만, 스크롤 한 정도에 따라 계산 가능한 상태를 갖기 때문에 스크롤에 매우 적합합니다.

그렇기에 `Sliver`는 단독으로 사용될 수 없고, `ListView`와 같이 스크롤을 가능하게 해주는 웨젯 내부에서 계산되서 사용되어야 하는 것입니다.
(`SingleChildScrollView`와 같은 단일 뷰포트 위젯 제외)

정리하자면, `Sliver`와 일반 위젯의 차이점은 간단하게 말하면 레이아웃이 가변적인지, 정적인지의 차이입니다.

### ListView

`ListView` 위젯을 사용하면 간단하게 여러 위젯들을 스크롤 가능하게 만들 수 있습니다.

> `SingleChildScrollView(child: Column())` 로도 되는거 아닌가요?

스크롤은 가능하게 할 수 있으나, 성능과 미적인(?) 측면에서 큰 차이를 내게 됩니다.

`SingleChildScrollView`는 일반 랜더 박스를 `child`로 받습니다.

즉, 수많은 위젯이 한 번에 빌드된다는 뜻이니 성능이 치명적이죠.

하지만, `ListView`는 여러 위젯들을 `children`의 배열의 형태로 받기 때문에 내부 구현에 의해 빌드 시점이 분산됩니다.

즉, 스크롤 위치에 따라 필요한 위젯만 빌드되기 때문에 성능에 이점이 있습니다.

### SliverList

`SliverList`는 스크롤에 따라 필요한 위젯들만 빌드한다는 점에서 `ListView`와 유사합니다.

차이점은 `Sliver`인지 아닌지와 내부 구현의 차이에 있습니다.

그렇기에 `SliverList`를 사용할 때는 반드시 `CustomScrollView`와 같은 `ScrollView`를 제공하는 위젯과 함께 사용해야 합니다.

### CustomScrollView

`ListView`와 마친가지로 `ScrollView`를 제공합니다.

다만, 차이점은 children이 아닌 `slivers`를 받는다는 점이죠.

그렇기에 딱딱한게 스크롤 가능했던 `ListView`와 달리 아주 특이한(?) 스크롤도 구현할 수 있습니다.
(이 모든게 `Sliver 프로토콜` 덕분!)

아래는 제가 개발하면서 궁금했던 점을 정리해 보았습니다.

> `SliverToBoxAdaptor(child: ListView(shrinkWrap: true))` 는 왜 일시에 모두 빌드가 되는 건가요?

`shrinkWrap`이 `false`라면 `ScrollView`가 스크롤 방향으로 최대치만큼 설정이 됩니다.
하지만, 중첩 스크롤이 되는 경우에는 최대치의 boundary가 없기 때문에 `shrinkWrap`을 `true`로 하며 자식의 크기만큼 `ScrollView` 크기를 제한해야 합니다.

이 때, `ScrollView` 크기가 자식의 크기만큼 제한되고(동일해짐), `SliverToBoxAdaptor`가 그 크기만큼의 크기를 갖게 되기 때문에 Flutter는 `ListView`의 모든 `children`이 화면에 보여져야 하는 상태로 인식하게 됩니다.

따라서 모든 위젯이 한 번에 빌드가 되어버리는 것이죠.

> `ListView`를 `CustomScrollView`로 마이그레이션 하고 싶어요.

`ListView`의 `children`들을 아래와 같이 넣어보세요.

```dart
CustomScrollView(
  slivers: [
    SliverList.builder(
      itemBuilder: (context, index) => children[index],
      itemCount: children.length,
    ),
  ],
),
```

## 마무리

이번 세션에서는 스크롤의 모든것, `Sliver`와 이를 활용한 `ListView`에 대해 알아보았습니다.

간단한 스크롤의 경우에는 `ListView`를, 복잡한 중첩 스크롤의 경우에는 성능 최적화를 위해 `CustomScrollView`를 사용하는 것이 좋습니다.

만약, 더욱 복잡한 스크롤의 경우에는, 특히 `Sliver`를 중첩으로 사용해야 하는 경우에는 [sliver_tools](https://pub.dev/packages/sliver_tools) 라는 라이브러리도 한 번 사용해 보시는 것을 권장 드립니다.
