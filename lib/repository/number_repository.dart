class NumberRepository {
  Future<int> getNumber(int value) async {
    await Future.delayed(const Duration(seconds: 1));

    var res = await Future.value(value);

    return res;
  }

  Stream<int> getNumStream() async* {
    for (var value in List.generate(5, (index) => index + 1)) {
      yield await getNumber(value);
    }
  }
}
