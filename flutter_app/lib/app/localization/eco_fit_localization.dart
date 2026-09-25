import '../state/eco_fit_app_state.dart';

bool get ecoFitIsEnglish => EcoFitAppState.instance.language == 'en';

String l10n(String vietnamese, String english) =>
    ecoFitIsEnglish ? english : vietnamese;

List<String> l10nList(List<String> vietnamese, List<String> english) =>
    ecoFitIsEnglish ? english : vietnamese;
