import 'package:flutter_test/flutter_test.dart';

import 'package:real_gamers_critics/functions/playstore/check_app.dart';

void main() {
  group("check_app.dart", () {
    test("isGame has problem", () async {
      expect(await isGame("com.yodo1.crossyroad"), true);
    });
  });
}
