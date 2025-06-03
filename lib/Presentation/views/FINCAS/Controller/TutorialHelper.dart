import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialHelper {
  static String getTutorialKey(String tutorialKeyFinca) {
    switch (tutorialKeyFinca.toUpperCase()) {
      case 'CAMANOVILLO':
        return "tutorial_mostrado_CAMANOVILLO_DATO";
      case 'EXCANCRIGRU':
        return "tutorial_mostrado_EXCANCRIGRU_DATOS";
      case 'FERTIAGRO':
        return "tutorial_mostrado_FERTIAGRO_DATOS";
      case 'GROVITAL':
        return "tutorial_mostrado_GROVITAL_DATOS";
      case 'SUFAAZA':
        return "tutorial_mostrado_SUFAAZA_DATOS";
      case 'TIERRAVID':
        return "tutorial_mostrado_TIERRAVID_DATOS";
      default:
        return "tutorial_mostrado_${tutorialKeyFinca.toUpperCase()}";
    }
  }

  static Future<bool> shouldShowTutorial(String tutorialKeyFinca) async {
    final prefs = await SharedPreferences.getInstance();
    final key = getTutorialKey(tutorialKeyFinca);
    return prefs.getBool(key) ?? true;
  }

  static Future<void> setTutorialShown(String tutorialKeyFinca) async {
    final prefs = await SharedPreferences.getInstance();
    final key = getTutorialKey(tutorialKeyFinca);
    await prefs.setBool(key, false);
  }

  static Future<void> resetTutorial(String tutorialKeyFinca, {bool reset = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = getTutorialKey(tutorialKeyFinca);
    await prefs.setBool(key, reset);
  }

  static Future<void> showTutorialIfNeeded({
    required BuildContext context,
    required List<TargetFocus> targets,
    required String tutorialKeyFinca,
    Function()? onFinish,
  }) async {
    if (await shouldShowTutorial(tutorialKeyFinca)) {
      TutorialCoachMark tutorial = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black87,
        paddingFocus: 0.01,
        showSkipInLastTarget: true,
        initialFocus: 0,
        useSafeArea: true,
        textSkip: "Saltar",
        focusAnimationDuration: const Duration(milliseconds: 500),
        unFocusAnimationDuration: const Duration(milliseconds: 500),
        pulseAnimationDuration: const Duration(milliseconds: 500),
        pulseEnable: true,
        onFinish: () {
          setTutorialShown(tutorialKeyFinca);
          if (onFinish != null) onFinish();
        },
        onClickTarget: (target) {
          debugPrint("Clicked on target: ${target.identify}");
        },
        onClickOverlay: (target) {
          debugPrint("Overlay clicked");
        },
      );

      tutorial.show(context: context);
    }
  }
}
