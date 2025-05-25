import 'package:call/models/post_model.dart' show PostModel;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdoptionScreen extends StatefulWidget {
  final PostModel post;

  const AdoptionScreen({super.key, required this.post});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  List<String> adoptedBy = []; // قائمة بالجمعيات التي تبنّت المشكلة

  final List<NgoModel> availableNgos = [
    NgoModel(
      name: 'جمعية الإغاثة',
      description: 'متخصصة في حالات الطوارئ',
      // ignore: deprecated_member_use
      icon: FontAwesomeIcons.handsHelping,
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
      // ignore: deprecated_member_use
      icon: FontAwesomeIcons.carCrash,
      color: Colors.green,
    ),
  ];

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
            Text(
              'تفاصيل البلاغ:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.post.description),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // قسم الجمعيات التي تبنّت المشكلة
            if (adoptedBy.isNotEmpty) ...[
              Text(
                'الجمعيات التي تبنّت المشكلة:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
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
                    return _buildAdoptedNgoCard(ngo);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

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
                children: availableNgos
                    .where((ngo) => !adoptedBy.contains(ngo.name))
                    .map((ngo) => _buildNgoCard(ngo))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdoptedNgoCard(NgoModel ngo) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        // ignore: deprecated_member_use
        border: Border.all(color: ngo.color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ngo.icon, color: ngo.color, size: 24),
          const SizedBox(height: 8),
          Text(
            ngo.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'تم التبني',
            style: TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNgoCard(NgoModel ngo) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showAdoptionConfirmation(context, ngo);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: ngo.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  ngo.icon,
                  color: ngo.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ngo.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ngo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdoptionConfirmation(BuildContext context, NgoModel ngo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد التبني'),
        content: Text('هل أنت متأكد من رغبة ${ngo.name} في تبني هذه المشكلة؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
              setState(() {
                adoptedBy.add(ngo.name);
              });
              Navigator.pop(context);
              _showAdoptionSuccess(context, ngo.name);
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAdoptionSuccess(BuildContext context, String ngoName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم التبني بنجاح'),
        content: Text('تم إرسال طلب التبني إلى $ngoName بنجاح'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('حسناً', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class NgoModel {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  NgoModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
