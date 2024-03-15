# flutter_flirting

## Intro

플러터 플러팅 네 번째 세션, `TextFormField` 세션입니다.

이번 세션에서는 `Stateful` 위젯 내부에서 `TextFormField`를 통해 사용자로부터 텍스트를 입력받는 과정과, 유효성 검사,
그리고 가상 키보드에 대응하는 화면 그리는 방법에 대해 알아보겠습니다.

## TextFormField

> 개발자의 덕목 첫 번째
> 사용자를 믿지 마라 -- 이웅재(?)

사용자로부터 데이터를 입력 받을 때 고려해야 할 사항이 한 두가지가 아닙니다.
아래는 제가 사용자로부터 데이터를 입력받을 때 고려하는 사항들 입니다.

1. 올바른 데이터인가? (null? 이메일 형식? 등등)
2. 텍스트 출력 방식이 올바른가? (비밀번호는 가리기 등)
3. 입력 절차가 간결하여 사용자가 데이터 입력에 거리낌이 없는가?
4. 가상 키보드가 화면 가독성에 영향을 주지는 않는가?

이 모든 고려사항을 충족 가능하게 해주는 위젯이 바로 `TextFormField` 입니다.

이번 세션은 파라미터 단위로 기능 설명이 아닌, 고려사항을 기준으로 파라미터를 설명해볼까 합니다.

### A1. 데이터 검증 방법

사용자의 데이터 형식이 올바른지 유효성 검사를 진행하는 방법은 `Form` 위젯과 `TextFormField` 위젯의 `validate` 파라미터의 조합으로 가능해집니다.

- Form

  Form 위젯은 화면을 그리는 위젯이 아닌, 하위 위젯들 중 사용자의 입력을 받는 위젯들의 컨트롤을 도와주는 위젯입니다.

  간단하게 사용하려면 `autovalidateMode` 파라미터에 `AutovalidateMode.always` 와 같은 값을 넣어주면 사용자 입력이 발생할 때 마다 하위 위젯들의 validate 함수를 동작 시킵니다.

  하지만, 이럴 경우에는 사용자 경험을 해칠 수도 있습니다.
  아직 입력이 안끝났는데 입력이 틀렸다고 에러를 내보내니 말이죠.

  따라서 제대로 사용하기 위해서는 `autovalidateMode` 파라미터를 사용하는 것이 아닌, `key` 파라미터를 사용하는 것입니다.

  `key` 파라미터에는 `GlobalKey<FormState>` 객체가 들어가는데, 해당 객체를 다음과 같이 조작하여 원하는 시점에 validate 함수를 동작시킬 수 있습니다.

  ```dart
    _formKey.currentState?.validate();
  ```

- validate

  위에서 `validate 함수`를 동작한다고 했었는데, `validate 함수`의 동작이란, TextFormField의 `validate` 파라미터에 등록된 함수의 실행을 의미합니다.

  `validate 함수`의 리턴값은 `String` 또는 `null` 타입인데,
  `null`이 리턴된다는 것은 **유효성 검사에 통과**했다는 의미이고,
  `String`이 리턴된다는 것은 **유효성 검사에 실패하였고, 실패한 이유를 String으로 반환**하여 사용자에게 알려주는 것입니다.

### A2. 비밀번호 숨기기(Obscure)

비밀번호가 직접적으로 노출되는 것을 숨기기 위해 **.** 과 같이 표시하곤 하는데요, 해당 기능을 이용하려면 `TextFormField`의 `obscureText` 파라미터를 `true` 값으로 설정하면 됩니다.

하지만, 대부분의 서비스를 보면 비밀번호 입력칸 오른쪽에 **'눈 모양'** 버튼이 있어,
해당 버튼을 누르면 비밀번호가 보여지는 기능을 제공하기도 합니다.

해당 기능을 구현하기 위해서는

1. 눈 모양 버튼을 `TextFormField`의 오른쪽에 위치시킨다
2. 눈 모양 버튼을 누르면 `obscureText`의 boolean 값을 반전시킨다

와 같은 기능을 구현해야 합니다.

1번은 `decoration` 파라미터의 인자로 들어가는 `InputDecoration` 위젯의 파라미터, `suffixIcon`에 위젯을 등록함으로서 해결할 수 있습니다.

2번은 비밀번호 노출 상태를 저장하는 `_isHide` 와 같은 상태 변수를 하나 만들고, `suffixIcon`에 등록된 위젯을 터치시 `_isHide` 값을 반전시킨 후 `setState` 함수를 호출하는 방식으로 구현할 수 있습니다.

코드로 구현하면 아래와 같이 되겠죠.

```dart
void _switchHide() {
  setState(() {
    _isHide = !_isHide;
  });
}

...

TextFormField(
  decoration: InputDecoration(
    suffixIcon: GestureDetector(
      onTap: _switchHide,
      child: Icon(
        _isHide
            ? Icons.remove_red_eye
            : Icons.remove_red_eye_outlined,
      ),
    ),
  ),
  obscureText: _isHide,
),
```

여기서 `GestureDetector`은 사용자의 화면 입력을 감지하는 위젯으로 이 위젯 역시 많이 사용되니 알아두시면 좋습니다.

간단하게 사용하자면, 사용자가 화면을 터치하면 `onTap` 파라미터에 등록된 함수가 실행되게 됩니다.

### A3. 사용자 편의성

이메일을 입력하려는데 키보드에 골뱅이(`@`) 키가 바로 안보인다거나,
필드 하나 입력을 끝낸 후 다음 버튼을 눌렀는데 다음 필드로 안넘어가고 키보드가 내려가면 사용자 입장에서는 불편함을 느끼게 될 것입니다. (제가 그러니까요...)

이런 부분에서 사용자의 편의성을 신경 써주기 위한 파라미터 역시 존재합니다.

- keyboardType

  필드 터치시 등장하는 가상 키보드의 타입을 지정하는 파라미터 입니다.

  이메일 전용 키보드의 경우 `TextInputType.emailAddress`,
  숫자 전용 키보드의 경우 `TextInputType.number` 등 여러 키보드 타입이 지원되니 이것저것 시도해보시고 적절한 키보드 타입을 고르시면 될 듯 합니다.

- textInputAction

  키보드의 "다음" 또는 "전송" 위치에 들어갈 버튼의 타입을 지정하는 파라미터 입니다.

  `TextInputAction.next`로 설정하는 경우 Focus가 자동으로 다음 필드로 이동하게 됩니다.
  (별 다른 설정을 하지 않았는데도 자동으로 다음 필드로 넘어가는 이유는 `FocusScope`와 관련이 있어 보입니다 (확실치 않음))

  `TextInputAction.done`으로 설정하는 경우 키보드가 내려가게 됩니다.

  이 외에도 여러 타입이 있으니 한 번 알아보세요!

또한, 기본적으로는 키보드의 "완료" 버튼을 누르기 전까지는 키보드가 절대 화면 아래로 내려가지 않는데요, 그 이유는 `TextFormField`에 Focus가 잡혀있기 때문입니다.

Focus를 해제하기 위해서는 `FocusScope.of(context).unfocus();` 를 호출하면 되는데요, 보통 `TextFormField`의 `onTapOutside` 파라미터에 등록된 함수 부분에 작성합니다.

참고로 `FocusScope.of(context).nextFocus();` 를 호출하면 자동으로 다음 필드로 포커스가 이동하게 됩니다.

### A4. 키보드 화면 대응

키보드가 올라오면 그 만큼 `Scaffold`의 `body` 사이즈가 줄어들게 되는데요, 그러면 화면이 위로 밀려 올라가기도 하고, 어쩔 때는 ui overflow가 발생하기도 합니다.

이런 문제를 막기 위해 `Scaffold`의 `resizeToAvoidBottomInset` 파라미터의 값을 `false`로 설정하면 키보드에 의한 `body`의 축소를 막을 수 있습니다.

하지만, 이렇게 한다고 했을 때 문제점이 여전히 존재합니다.

UI가 하단에 위치하고 있는 경우, 키보드가 올라오면 `TextFormField`가 키보드 아래로 숨어버리는 현상이 발생할 수 있죠.

이런 화면 변화에 대응하고자 유용한 클래스가 있습니다.
바로 `MediaQuery` 입니다.

`MediaQuery`는 사용자 기기 화면에 대한 정보를 담고있는 클래스로 화면 사이즈나, 키보드 영역 높이, `SafeArea` 에 대한 정보를 가져올 수 있습니다.

`MediaQuery.of(context).viewInsets.bottom` 을 사용해서 실시간 키보드 영역 사이즈를 가져올 수 있습니다.

즉, 키보드 영역보다 반드시 위에 존재해야 하는 위젯 바로 아래 부분에 다음과 같은 코드를 추가하면 해당 영역은 반드시 키보드 위에 존재하게 되며, 화면 변화도 부드럽게 이루어지게 됩니다.

```dart
SizedBox(
  height: math.max(300, MediaQuery.of(context).viewInsets.bottom),
),
```

이 외에도 `MediaQuery.of(context).padding` 을 사용하면 `SafeArea`의 크기도 구할 수 있으니 아주 유용하다고 할 수 있습니다.

하지만, 무분별한 사용은 성능에 영향을 미치게 되기 때문에 가급적이면 최소한으로만 사용하도록 합시다.

## 마무리

이번 세션은 구현 중심으로 `TextFormField`에 대해 알아봤는데요, 그 만큼 `TextFormField`에 유용한 파라미터가 매우 많고, 외부적으로도 사용해야 하는 기능들이 많아서 그렇습니다.

단순하게 데이터를 받는 목적으로만 사용한다면 이렇게 여러 고민을 할 필요는 없겠지만, 사용자의 편의성을 위해, 그리고 더 나은 개발자가 되기 위한 이런 고민들은 분명 좋은 것입니다.

따라서 오늘 소개드린 내용 외에도 본인이 아쉽다고 느끼는 부분이 있다면 여러 시도를 통해 개선해보는 시간을 가져보셨으면 좋겠습니다.
