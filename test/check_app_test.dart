import 'package:flutter_test/flutter_test.dart';

import 'package:real_gamers_critics/functions/playstore/check_app.dart';

void main() {
  group("check_app.dart", () {
    test("isGame has problem", () async {
      expect(await isGame("com.yodo1.crossyroad"), true);
      expect(await isGame("com.google.android.youtube"), false);

      expect(await getGenre("com.yodo1.crossyroad"), "ACTION");
      expect(await getGenre("com.google.android.youtube"), null);
      expect(await getGenre("not exist"), "UNKNOWN");
    });
  });
}
