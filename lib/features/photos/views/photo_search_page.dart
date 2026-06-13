import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/photo_provider.dart';

class PhotoSearchPage extends ConsumerStatefulWidget {
  const PhotoSearchPage({super.key});

  @override
  ConsumerState<PhotoSearchPage> createState() => _PhotoSearchPageState();
}

class _PhotoSearchPageState extends ConsumerState<PhotoSearchPage> {
  final _controller = TextEditingController();
  DateTimeRange? _selectedRange;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: _selectedRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
    );
    if (picked != null) {
      setState(() => _selectedRange = picked);
      ref.read(photoFilterProvider.notifier).state =
          ref.read(photoFilterProvider).copyWith(dateRange: picked);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('搜索照片')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '按标签搜索...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (q) => ref
                  .read(photoFilterProvider.notifier)
                  .state = ref
                  .read(photoFilterProvider)
                  .copyWith(searchQuery: q),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(_selectedRange != null
                  ? '${_selectedRange!.start.year}/${_selectedRange!.start.month}/${_selectedRange!.start.day} - ${_selectedRange!.end.year}/${_selectedRange!.end.month}/${_selectedRange!.end.day}'
                  : '按日期范围筛选'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDateRange,
            ),
            if (_selectedRange != null)
              TextButton(
                onPressed: () {
                  setState(() => _selectedRange = null);
                  ref.read(photoFilterProvider.notifier).state =
                      ref.read(photoFilterProvider).copyWith(dateRange: null);
                },
                child: const Text('清除日期筛选'),
              ),
          ],
        ),
      ),
    );
  }
}
