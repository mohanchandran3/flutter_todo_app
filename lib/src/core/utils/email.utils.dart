import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailUtils {
  static Future<String> generateTaskLink(String taskId) async {
    try {
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://todoappwithsharing.page.link.com'),
        uriPrefix: 'https://todoappwithsharing.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.example.flutter_todo_app',
          minimumVersion: 1,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Shared Task',
          description: 'Check out this shared task',
        ),
      );

      final dynamicLink =
      await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

      return dynamicLink.toString();
    } catch (e) {
      return 'https://todoappwithsharing.page.link/tasks?id=$taskId';
    }
  }

  static Future<void> sendTaskByEmail({
    required BuildContext context,
    required String recipientEmail,
    required String subject,
    required String body,
    required String taskId,
  }) async {
    try {
      final taskLink = await generateTaskLink(taskId);
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

      if (recipientEmail.isEmpty || !emailRegex.hasMatch(recipientEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
        return;
      }

      final mailtoLink = Uri(
        scheme: 'mailto',
        path: recipientEmail,
        queryParameters: {
          'subject': subject,
          'body': '$body\n\nAccess the task here:\n$taskLink',
        },
      ).toString();

      if (await canLaunchUrl(Uri.parse(mailtoLink))) {
        await launchUrl(
          Uri.parse(mailtoLink),
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(
          '$subject\n\n$body\n\nAccess the task here:\n$taskLink',
          subject: subject,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}