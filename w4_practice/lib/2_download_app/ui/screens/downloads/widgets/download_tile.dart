import 'package:flutter/material.dart';

import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  // TODO
  Widget _buildTrailing(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.notDownloaded:
        return IconButton(
          onPressed: controller.startDownload,
          icon: const Icon(Icons.download),
        );
      case DownloadStatus.downloading:
        return Icon(Icons.downloading_rounded);
      case DownloadStatus.downloaded:
        return const Icon(Icons.folder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(controller.ressource.name),
                subtitle:
                    controller.status == DownloadStatus.downloading ||
                        controller.status == DownloadStatus.downloaded
                    ? Text(
                        '${(controller.progress * 100)}% Completed - ${controller.progress * controller.ressource.size} of ${controller.ressource.size} MB',
                      )
                    : Text(""),
                trailing: _buildTrailing(controller.status),
              ),
            ),
          ),
        );
      },
    );

    // TODO
  }
}
