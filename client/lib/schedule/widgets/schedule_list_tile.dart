import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/schedule/schedule.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    required this.item,
    required this.viewerPerson,
    super.key,
    this.onToggleCompleted,
    this.onTap,
  });

  final Item item;
  final ValueChanged<bool>? onToggleCompleted;
  final VoidCallback? onTap;
  final Person? viewerPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;
    final avatar = Avatar(
      photo: (item.responsible ?? viewerPerson)?.pictureUrl,
    );

    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              style: !item.isCompleted
                  ? const TextStyle(overflow: TextOverflow.ellipsis)
                  : TextStyle(
                      color: captionColor,
                      decoration: TextDecoration.lineThrough,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ],
      ),
      subtitle: _buildSubtitle(context),
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: item.isCompleted,
        onChanged: onToggleCompleted == null || !item.canToggle
            ? null
            : (value) => onToggleCompleted!(value!),
      ),
      trailing: onTap == null || !item.canUpdate
          ? Padding(
              padding: const EdgeInsets.only(right: 24),
              child: avatar,
            )
          : FittedBox(
              child: Row(
                children: [
                  avatar,
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final state = context.watch<ScheduleBloc>().state;
    if (state.order == ScheduleViewOrder.byEstimate) {
      return _buildEstimateSubtitle(context);
    } else {
      return _buildEndDateSubtitle(context);
    }
  }

  Widget? _buildEstimateSubtitle(BuildContext context) {
    final l10n = context.l10n;
    final estimate = item.estimate;

    final estimateParts = <String>[];
    if (estimate.days > 0) {
      estimateParts.add(l10n.scheduleItemEstimateDays(estimate.days));
    }
    if (estimate.hours > 0) {
      estimateParts.add(l10n.scheduleItemEstimateHours(estimate.hours));
    }
    if (estimate.minutes > 0) {
      estimateParts.add(l10n.scheduleItemEstimateMinutes(estimate.minutes));
    }

    if (estimateParts.isEmpty) {
      estimateParts.add(l10n.scheduleItemEstimateMissing);
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            estimateParts.join(', '),
            maxLines: 1,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }

  Widget? _buildEndDateSubtitle(BuildContext context) {
    final l10n = context.l10n;
    final endDate = item.endDate;

    if (endDate == null) {
      return null;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            DateFormat.yMMMMEEEEd(l10n.localeName).format(endDate),
            maxLines: 1,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
