import 'package:flutter/material.dart';

class AddPositionBottomSheet extends StatefulWidget {
  const AddPositionBottomSheet({super.key});

  @override
  State<AddPositionBottomSheet> createState() => _AddPositionBottomSheetState();
}

class _AddPositionBottomSheetState extends State<AddPositionBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama posisi tidak boleh kosong")),
      );
      return;
    }

    // TODO: tambahkan aksi bloc submit di sini
    // context.read<PositionsBloc>().add(AddPositionRequested(name));

    Navigator.pop(context, name); // return ke caller
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tambah Posisi Baru',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Posisi',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
