import 'package:frank_salazar/page/widgets/bottom_modal.dart';

class NavItemnModal {
  final String title;
  final RiveModel rive;

  NavItemnModal({required this.title, required this.rive});
}

List<NavItemnModal> bottomNavItems = [
  NavItemnModal(
      title: "Chat",
      rive: RiveModel(
          src: "assets/lotties/animated-icons.riv",
          artboard: "HOME",
          stateMachineName: "CHAT_INTERCATIVITY")),
  NavItemnModal(
      title: "Refresh",
      rive: RiveModel(
          src: "assets/lotties/animated-icons.riv",
          artboard: "REFRESH/RELOAD",
          stateMachineName: "CHAT_INTERCATIVITY")),
  NavItemnModal(
      title: "Search",
      rive: RiveModel(
          src: "assets/lotties/animated-icons.riv",
          artboard: "SEARCH",
          stateMachineName: "CHAT_INTERCATIVITY")),
];
