import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/event_provider.dart';
import '../../../core/database/database.dart';

class EventFormPage extends ConsumerStatefulWidget {
  final int? eventId;
  const EventFormPage({super.key, this.eventId});

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  String _type = '自定义';
  bool _isLunar = false;
  EventRepeatRule _repeatRule = EventRepeatRule.none;

  final _types = ['生日', '纪念日', '节日', '自定义'];

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final errors = EventFormData.validate(
      title: _titleController.text,
      date: _selectedDate,
    );
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errors.first)));
      return;
    }

    final db = ref.read(databaseProvider);
    final dateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    if (widget.eventId != null) {
      await (db.update(db.events)
            ..where((t) => t.id.equals(widget.eventId!)))
          .write(EventsCompanion(
        title: Value(_titleController.text),
        date: Value(dateStr),
        type: Value(_type),
        lunarFlag: Value(_isLunar),
        repeatRule: Value(_repeatRule.toRepeatRule()),
        notes: Value(
            _notesController.text.isNotEmpty ? _notesController.text : null),
      ));
    } else {
      await db.into(db.events).insert(EventsCompanion(
        title: Value(_titleController.text),
        date: Value(dateStr),
        type: Value(_type),
        lunarFlag: Value(_isLunar),
        repeatRule: Value(_repeatRule.toRepeatRule()),
        notes: Value(
            _notesController.text.isNotEmpty ? _notesController.text : null),
      ));
    }

    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId != null ? '编辑事件' : '添加事件'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '标题',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(_selectedDate != null
                ? '${_selectedDate!.year}年${_selectedDate!.month}月${_selectedDate!.day}日'
                : '选择日期'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          const Divider(),
          DropdownButtonFormField<String>(
            value: _type,
            decoration: const InputDecoration(labelText: '类型'),
            items: _types
                .map((t) =>
                    DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('农历日期'),
            value: _isLunar,
            onChanged: (v) => setState(() => _isLunar = v),
          ),
          DropdownButtonFormField<EventRepeatRule>(
            value: _repeatRule,
            decoration: const InputDecoration(labelText: '重复'),
            items: EventRepeatRule.values
                .map((r) => DropdownMenuItem(
                    value: r, child: Text(r.label)))
                .toList(),
            onChanged: (v) => setState(() => _repeatRule = v!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: '备注',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
