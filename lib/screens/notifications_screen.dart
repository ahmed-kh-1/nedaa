import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:call/models/post_model.dart';
import 'package:call/models/ngo_model.dart';
import 'package:call/widgets/adopted_ngo_card.dart';
import 'package:call/widgets/available_ngo_card.dart';
import 'package:call/widgets/post_detail_card.dart';

class AdoptionScreen extends StatefulWidget {
  final PostModel post;

  const AdoptionScreen({super.key, required this.post});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  List<String> adoptedBy = [];

  final List<NgoModel> availableNgos = [
    NgoModel(
      name: 'جمعية الإغاثة',
      description: 'متخصصة في حالات الطوارئ',
      icon: FontAwesomeIcons.handshake,
      color: Colors.blue,
    ),
    NgoModel(
      name: 'جمعية الرحمة',
      description: 'متخصصة في الحالات الصحية',
      icon: FontAwesomeIcons.heart,
      color: Colors.red,
    ),
    NgoModel(
      name: 'جمعية الإحسان',
      description: 'متخصصة في حالات الحريق',
      icon: FontAwesomeIcons.fireExtinguisher,
      color: Colors.orange,
    ),
    NgoModel(
      name: 'جمعية الأمل',
      description: 'متخصصة في الحوادث المرورية',
      icon: FontAwesomeIcons.carBurst,
      color: Colors.green,
    ),
  ];

  void _showAdoptionConfirmation(NgoModel ngo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد التبني'),
        content: Text('هل أنت متأكد من رغبة ${ngo.name} في تبني هذه المشكلة؟'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() => adoptedBy.add(ngo.name));
              Navigator.pop(context);
              _showAdoptionSuccess(ngo.name);
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAdoptionSuccess(String ngoName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم التبني بنجاح'),
        content: Text('تم إرسال طلب التبني إلى $ngoName بنجاح'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
            const SizedBox(height: 20),
            const Text(
              'تفاصيل البلاغ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PostDetailCard(post: widget.post),
            const SizedBox(height: 30),
            if (adoptedBy.isNotEmpty) ...[
              const Text(
                'الجمعيات التي تبنّت المشكلة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: adoptedBy.length,
                  itemBuilder: (context, index) {
                    final ngo = availableNgos.firstWhere(
                      (n) => n.name == adoptedBy[index],
                      orElse: () => availableNgos[0],
                    );
                    return AdoptedNgoCard(ngo: ngo);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'الجمعيات المتاحة للتبني:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: availableNgos
                    .where((ngo) => !adoptedBy.contains(ngo.name))
                    .map((ngo) => AvailableNgoCard(
                          ngo: ngo,
                          onTap: () => _showAdoptionConfirmation(ngo),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
