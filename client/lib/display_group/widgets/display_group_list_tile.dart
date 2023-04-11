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
      title: Text(
        participant.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Avatar(photo: participant.pictureUrl),
    );
  }
}
