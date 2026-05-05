import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {
  const ExpandableContainer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(Grid.m),
      margin: const EdgeInsets.only(bottom: Grid.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Grid.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: Grid.s,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Grid.m,
                  right: Grid.m,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TTitle(
                      widget.title,
                      fontWeight: FontWeight.bold,
                    )),
                    Icon(
                      isExpanded
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
              opacity: isExpanded ? 1.0 : 0.0,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: Grid.m,
                        right: Grid.m,
                      ),
                      child: widget.child,
                    )
                  : null),
        ],
      ),
    );
  }
}
