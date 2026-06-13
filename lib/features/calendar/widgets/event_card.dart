import 'package:flutter/material.dart';
import '../../../core/database/database.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final typeIcons = {
      '生日': Icons.cake,
      '纪念日': Icons.favorite,
      '节日': Icons.celebration,
      '自定义': Icons.event,
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(typeIcons[event.type] ?? Icons.event,
            color: Theme.of(context).colorScheme.primary),
        title: Text(event.title),
        subtitle: event.notes != null && event.notes!.isNotEmpty
            ? Text(event.notes!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (event.lunarFlag)
              const Chip(
                  label: Text('农历', style: TextStyle(fontSize: 10))),
            if (event.repeatRule != null)
              const Icon(Icons.repeat, size: 16, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
