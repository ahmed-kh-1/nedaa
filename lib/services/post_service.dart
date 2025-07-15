import '../models/post_model.dart';

class PostService {
  Future<List<PostModel>> fetchPosts() async {
    return _getDemoPosts();
  }

  List<PostModel> _getDemoPosts() {
    return [
      PostModel(
        userName: 'أحمد محمد',
        timeAgo: 'منذ 10 دقائق',
        title: 'حادث مروري على شارع الملك فهد',
        description:
            'حدث تصادم بين 3 سيارات نتج عنه إصابة شخصين، يرجى تجنب المنطقة',
        likes: 24,
        comments: 8,
      ),
      PostModel(
        userName: 'نورا عبدالله',
        timeAgo: 'منذ ساعة',
        title: 'انقطاع كهرباء في حي العليا',
        description:
            'انقطع التيار الكهربائي عن حي العليا منذ الساعة 3 عصراً ولم يتم إصلاحه بعد',
        likes: 42,
        comments: 15,
      ),
      PostModel(
        userName: 'خالد سعد',
        timeAgo: 'منذ ساعتين',
        title: 'حريق في مبنى سكني',
        description:
            'اندلع حريق في الطابق الثالث من مبنى سكني بحي النزهة، فرق الدفاع المدني تعمل على إخماده',
        likes: 56,
        comments: 23,
      ),
      PostModel(
        userName: 'لينا فارس',
        timeAgo: 'منذ 3 ساعات',
        title: 'تحذير من عاصفة رملية',
        description:
            'توقعات بعاصفة رملية شديدة خلال الساعات القادمة، يرجى اتخاذ الاحتياطات اللازمة',
        likes: 31,
        comments: 12,
      ),
      PostModel(
        userName: 'ياسر ناصر',
        timeAgo: 'منذ 5 ساعات',
        title: 'انزلاق تربة على طريق الرياض-الدمام',
        description:
            'أدى هطول الأمطار الغزيرة إلى انزلاق التربة وإغلاق جزئي للطريق',
        likes: 18,
        comments: 7,
      ),
      PostModel(
        userName: 'سارة علي',
        timeAgo: 'منذ 6 ساعات',
        title: 'تحذير من ارتفاع منسوب المياه',
        description:
            'مناطق في شرق المدينة معرضة لارتفاع منسوب المياه، يرجى الحذر',
        likes: 29,
        comments: 11,
      ),
      PostModel(
        userName: 'فهد خالد',
        timeAgo: 'منذ يوم',
        title: 'أعمال صيانة على طريق الأمير تركي',
        description: 'أعمال صيانة مستمرة حتى مساء الغد، يفضل استخدام طرق بديلة',
        likes: 13,
        comments: 4,
      ),
    ];
  }
}
