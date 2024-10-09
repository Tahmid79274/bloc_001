import 'package:bloc101/bloc/app_bloc.dart';
import 'package:bloc101/bloc/app_event.dart';
import 'package:bloc101/bloc/app_state.dart';
import 'package:bloc101/view/main_popup_menu_button.dart';
import 'package:bloc101/view/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
              onPressed: () async {
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image == null) return;
                context
                    .read<AppBloc>()
                    .add(AppEventUploadImage(filePathUpload: image.path));
              },
              icon: const Icon(Icons.upload)),
          IconButton(onPressed: () async {}, icon: const Icon(Icons.upload)),
          const MainPopupMenuButton()
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: images
            .map(
              (img) => StorageImageView(image: img),
            )
            .toList(),
      ),
    );
  }
}
