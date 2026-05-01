import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/media_item.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ImageFieldWidget extends StatefulWidget {
  final FieldEntity field;
  final MediaItem? value;
  final ValueChanged<MediaItem?> onChanged;

  const ImageFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  final ImagePicker _picker = ImagePicker();
  late MediaItem? _initialMedia;

  @override
  void initState() {
    super.initState();
    _initialMedia = widget.value;
  }

  void _handleChanged(MediaItem? newValue) {
    setState(() {
      _initialMedia = newValue;
    });
    widget.onChanged.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final media = _initialMedia;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        if (media != null) ...[
          _buildMedia(
            media,
          )
        ] else ...[
          DashedButton(
            height: 200,
            borderColor: Theme.of(context).disabledColor,
            color: Theme.of(context).colorScheme.primary,
            onTap: () => _showPickSourceSheet(context),
            title: "Pilih Gambar",
            icon: Icons.image,
          )
        ]
      ],
    );
  }

  Widget _buildMedia(MediaItem item) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: item.isNetwork
                ? Image.network(
                    item.path,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const SmartShimmer();
                    },
                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(Icons.broken_image),
                      );
                    },
                  )
                : Image.file(
                    File(item.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: GestureDetector(
            onTap: _clearImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    final picked = await _picker.pickImage(
      source: source,
    );

    if (picked == null) return;
    _handleChanged(
      MediaItem(
        path: picked.path,
        isNetwork: false,
      ),
    );
  }

  void _clearImage() {
    _handleChanged(null);
  }

  Future<void> _showPickSourceSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Kamera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Galeri"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
