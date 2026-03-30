import 'dart:convert';
import 'package:http/http.dart' as http;

/// Script sederhana untuk test Open Library API
/// Run: dart test_openlibrary_api.dart
void main() async {
  print('🧪 Testing Open Library API...\n');

  // Test 1: Search Fiction Novels
  print('📚 Test 1: Search Fiction Novels');
  await testSearchNovels('fiction');

  // Test 2: Search Fantasy Novels
  print('\n🐉 Test 2: Search Fantasy Novels');
  await testSearchNovels('fantasy');

  // Test 3: Search by Title
  print('\n🔍 Test 3: Search by Title');
  await testSearchNovels('pride and prejudice');

  // Test 4: Test Cover Image URL
  print('\n🖼️ Test 4: Test Cover Image URL');
  testCoverImage(840881);

  print('\n✅ All tests completed!');
}

Future<void> testSearchNovels(String query) async {
  final url = Uri.parse(
    'https://openlibrary.org/search.json?q=subject:$query&limit=5&fields=key,title,author_name,cover_i,first_publish_year,rating_average,subject',
  );

  print('🔗 URL: $url');

  try {
    final response = await http.get(url);

    print('📡 Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final docs = data['docs'] as List;

      print('✅ Found ${docs.length} results\n');

      for (var doc in docs) {
        final title = doc['title'] ?? 'N/A';
        final authors = (doc['author_name'] as List?)?.first ?? 'Unknown';
        final coverId = doc['cover_i'] ?? 'No cover';
        final year = doc['first_publish_year'] ?? 'N/A';
        final rating = doc['rating_average'] ?? 'No rating';

        print('📖 Title: $title');
        print('   Author: $authors');
        print('   Year: $year');
        print('   Rating: $rating');
        print('   Cover ID: $coverId');
        if (coverId != 'No cover') {
          print('   Cover URL: https://covers.openlibrary.org/b/id/$coverId-L.jpg');
        }
        print('');
      }
    } else {
      print('❌ Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
}

void testCoverImage(int coverId) {
  final url = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
  print('Cover URL: $url');
  print('Test di browser untuk verify');
}
