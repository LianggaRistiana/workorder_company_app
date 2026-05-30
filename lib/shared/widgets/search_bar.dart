import 'dart:async';
import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  final String featureName;
  final String? initialValue;
  final void Function(String) onChanged;
  final Duration debounceDuration;

  const AppSearchBar({
    super.key,
    required this.featureName,
    required this.onChanged,
    this.initialValue,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _hasText = _controller.text.isNotEmpty;
  }

  void _onTextChanged(String value) {
    setState(() => _hasText = value.isNotEmpty);

    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(value);
    });
  }

  void _clearText() {
    _controller.clear();
    setState(() => _hasText = false);
    _debounce?.cancel();
    widget.onChanged('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        hintText: "Cari ${widget.featureName}",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearText,
                tooltip: 'Hapus pencarian',
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onChanged: _onTextChanged,
    );
  }
}
