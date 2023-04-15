
import 'dart:core';
import 'dart:io';

import 'package:documents_saver_app/src/features/ticket_storage/domain/models/tickets_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/database/tickets_storage_helper.dart';
import '../models/ticket.dart';

import 'package:path/path.dart' show basename;

class FileManagerRepository {
  late final TicketStorageHelper _ticketStorage;
  late final DownloadManager _dm;

  FileManagerRepository() {
    _ticketStorage = TicketStorageHelper.instance;
    _dm = DownloadManager();
  }

  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _ticketStorage.updateTicket(ticket);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Something went wrong.");
    }
  }

  Future<DownloadTask?> downloadTicketFile(
    Ticket ticket,
  ) async {
    try {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      final fileName = basename(ticket.fileUrl);

      final saveFilePath = '${appDocumentsDir.path}/$fileName';

      final task = _dm.addDownload(ticket.fileUrl, saveFilePath);
      return task;
    } catch (e) {
      debugPrint(
        "FileManagerRepository - downloadTicketFile - ${e.toString()}",
      );

      throw Exception("Something went wrong.");
    }
  }

  Future<void> pauseDownloadTicketFile(
    Ticket ticket,
  ) async {
    try {
      await _dm.pauseDownload(ticket.fileUrl);
    } catch (e) {
      debugPrint(
        "FileManagerRepository - pauseDownloadTicketFile - ${e.toString()}",
      );

      throw Exception("Something went wrong.");
    }
  }
}