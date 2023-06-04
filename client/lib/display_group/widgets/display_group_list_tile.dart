import 'package:flutter/material.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class DisplayGroupListTile extends StatelessWidget {
  const DisplayGroupListTile({
    required this.participant,
    super.key,
  });

  final Person participant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              participant.name,
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
      leading: Avatar(photo: participant.pictureUrl),
    );
  }
}
