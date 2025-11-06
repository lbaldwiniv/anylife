import 'package:anylife/widgets/navbar.dart';
import 'package:anylife/widgets/squashbutton.dart';
import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../utils/player_data_loader.dart';
import '../utils/snapshot_manager.dart';
import '../widgets/timeline/index.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  PlayerModel? player;
  final SnapshotManager snapshotManager = SnapshotManager();
  final Map<String, bool> _yearExpansionState = {};
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _monthKeys = {};

  @override
  void initState() {
    super.initState();
    loadPlayerData().then((loadedPlayer) {
      final String currentYear = _getCurrentYearLabel(loadedPlayer.ageInMonths);
      setState(() {
        player = loadedPlayer;
        _yearExpansionState[currentYear] = true;
      });
    });
  }

  String _getCurrentYearLabel(int ageInMonths) {
    final currentYear = ageInMonths ~/ 12;
    return "$currentYear Years Old";
  }

  void _advanceAge() {
    if (player == null) return;

    snapshotManager.saveSnapshot('month_${player!.ageInMonths}', player!);

    final int oldYear = player!.ageInMonths ~/ 12;

    setState(() {
      player!.ageInMonths += 1;
      final int newYear = player!.ageInMonths ~/ 12;

      if (newYear != oldYear) {
        final oldYearLabel = "$oldYear Years Old";
        final newYearLabel = "$newYear Years Old";

        _yearExpansionState[oldYearLabel] = false;
        _yearExpansionState[newYearLabel] = true;
      }
    });

    // Smooth scroll after animation finishes
    Future.delayed(const Duration(milliseconds: 260), () {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });

    debugPrint("Aged to ${player!.ageInMonths} months");
  }

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileBar(player: player!),
            Expanded(
              child: TimelineView(
                player: player!,
                yearExpansionState: _yearExpansionState,
                monthKeys: _monthKeys,
                scrollController: _scrollController,
              ),
            ),
            // This is the "Age" button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SquashableButton(
                onPressed: _advanceAge,
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary, width: 4),
                  ),
                  child: Text(
                    'Next Month',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            const Navbar(),
          ],
        ),
      ),
    );
  }
}
