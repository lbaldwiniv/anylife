import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../../utils/timeline_manager.dart';


class TimelineView extends StatelessWidget {
  final PlayerModel player;
  final Map<String, bool> yearExpansionState;
  final Map<String, GlobalKey> monthKeys;
  final ScrollController scrollController;

  const TimelineView({
    super.key,
    required this.player,
    required this.yearExpansionState,
    required this.monthKeys,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final timelineMap = TimelineManager.buildTimelineStructure(player);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: timelineMap.entries.map((entry) {
                  final String yearLabel = entry.key;
                  final List<String> months = entry.value;
                  final bool isExpanded =
                      yearExpansionState[yearLabel] ?? false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          yearExpansionState[yearLabel] = !isExpanded;
                          (context as Element)
                              .markNeedsBuild(); // TEMP workaround
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                yearLabel,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topLeft,
                        child: isExpanded
                            ? Column(
                                children: months.map((month) {
                                  final String monthId = '$yearLabel-$month';
                                  monthKeys.putIfAbsent(
                                      monthId, () => GlobalKey());
                                  return Container(
                                    key: monthKeys[monthId],
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      month,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
