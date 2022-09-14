import 'dart:typed_data';

import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/utils.dart';

OverlayEntry? _overlayEntry;

class PdfPage extends StatelessWidget {
  final List<int> bytes;

  PdfPage(
    this.bytes, {
    Key? key,
  }) : super(key: key);

  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStr.invoice.toUpperCase(),
          style: Get.textTheme.bodyText1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.ios_share,
              color: AppColors.textColor(),
            ),
            onPressed: () async {
              await shareFile(
                'INV_${DateTime.now()}.pdf',
                Uint8List.fromList(bytes),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.memory(
              Uint8List.fromList(bytes),
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
              controller: _pdfViewerController,
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: (details.globalSelectedRegion?.center.dy ?? 0) - 55,
        left: details.globalSelectedRegion?.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          child: Text(AppStr.copy, style: Get.textTheme.subtitle1),
        ),
      ),
    );
    _overlayState?.insert(_overlayEntry!);
  }
}
