// ignore_for_file: deprecated_member_use

import 'package:call/models/post_model.dart' show PostModel;
import 'package:call/widgets/orgnizations/orgnization_card.dart';
import 'package:call/widgets/report_details_card.dart' show ReportDetailsCard;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class AdoptionScreen extends StatelessWidget {
  final PostModel post;

  const AdoptionScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تبني المشكلة'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6A1B9A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportDetailsCard(post: post),
            const SizedBox(height: 30),
            Text(
              'الجمعيات المتاحة للتبني:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: const [
                  NgoCard(
                    name: 'جمعية الإغاثة',
                    specialization: 'متخصصة في حالات الطوارئ',
                    icon: FontAwesomeIcons.handsHelping,
                    color: Colors.blue,
                  ),
                  NgoCard(
                    name: 'جمعية الرحمة',
                    specialization: 'متخصصة في الحالات الصحية',
                    icon: FontAwesomeIcons.heart,
                    color: Colors.red,
                  ),
                  NgoCard(
                    name: 'جمعية الإحسان',
                    specialization: 'متخصصة في حالات الحريق',
                    icon: FontAwesomeIcons.fireExtinguisher,
                    color: Colors.orange,
                  ),
                  NgoCard(
                    name: 'جمعية الأمل',
                    specialization: 'متخصصة في الحوادث المرورية',
                    icon: FontAwesomeIcons.carBurst,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
