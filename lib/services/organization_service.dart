import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/organization_model.dart';

class OrganizationService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'organizations';

  Future<void> addOrganization(OrganizationModel org) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final orgnization = org.copyWith(ownerId: userId);
      await _supabase.from(_table).insert(orgnization.toMap());
    } catch (e) {
      print("error : ${e.toString()}");
      throw Exception('فشل في إضافة الجمعية: $e');
    }
  }

  Future<void> updateOrganization(String id, OrganizationModel org) async {
    try {
      await _supabase.from(_table).update(org.toMap()).eq('id', id);
    } catch (e) {
      print("error : ${e.toString()}");
      throw Exception('فشل في تحديث الجمعية: $e');
    }
  }

  Future<void> deleteOrganization(String id) async {
    try {
      await _supabase.from(_table).delete().eq('id', id);
    } catch (e) {
      print("error : ${e.toString()}");
      throw Exception('فشل في حذف الجمعية: $e');
    }
  }

  Future<List<OrganizationModel>> getAllOrganizations() async {
    try {
      final List data = await _supabase.from(_table).select();
      return data.map((e) => OrganizationModel.fromMap(e)).toList();
    } catch (e) {
      print("error : ${e.toString()}");
      throw Exception('فشل في جلب الجمعيات: $e');
    }
  }

  Future<OrganizationModel?> getOrganizationById(String id) async {
    try {
      final data = await _supabase.from(_table).select().eq('id', id).single();
      return OrganizationModel.fromMap(data);
    } catch (e) {
      print("error : ${e.toString()}");
      throw Exception('فشل في جلب الجمعية: $e');
    }
  }
}
