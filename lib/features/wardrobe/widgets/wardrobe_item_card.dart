import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/database/database.dart';
import '../providers/wardrobe_provider.dart';

class WardrobeItemCard extends StatelessWidget {
  final WardrobeItem item;
  final VoidCallback onTap;

  const WardrobeItemCard(
      {super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.file(
                File(item.photoPath),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      WardrobeSeason.fromString(item.season).displayName,
                      style: const TextStyle(fontSize: 10),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (item.color != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _parseColor(item.color!),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorName) {
    final colors = {
      '红': Colors.red, '橙': Colors.orange, '黄': Colors.yellow,
      '绿': Colors.green, '蓝': Colors.blue, '紫': Colors.purple,
      '黑': Colors.black, '白': Colors.white, '灰': Colors.grey,
      '棕': Colors.brown,
    };
    return colors[colorName] ?? Colors.grey;
  }
}
