# 🔌 API Integration Guide

Panduan untuk mengintegrasikan aplikasi dengan backend API.

## 📡 API Endpoints yang Dibutuhkan

### Authentication
```
POST   /api/auth/login
POST   /api/auth/register
POST   /api/auth/logout
GET    /api/auth/me
```

### Books
```
GET    /api/books              # Get all books
GET    /api/books/:id          # Get book detail
GET    /api/books/search?q=    # Search books
GET    /api/books/category/:cat # Filter by category
```

### Chapters
```
GET    /api/books/:id/chapters
GET    /api/chapters/:id
```

### User
```
GET    /api/user/profile
PUT    /api/user/profile
GET    /api/user/reading-history
POST   /api/user/favorites/:bookId
```

## 🔧 Implementation Steps

### 1. Update API Service

File: `lib/services/api_service.dart`

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends GetxService {
  static const String baseUrl = 'https://your-api.com/api';
  
  final _storage = Get.find<SharedPreferences>();

  Map<String, String> get headers {
    final token = _storage.getString(AppConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET Request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 401:
        // Unauthorized - logout user
        Get.find<AuthController>().logout();
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not found');
      case 500:
        throw Exception('Server error');
      default:
        throw Exception('Error: ${response.statusCode}');
    }
  }
}
```

### 2. Update Auth Controller

File: `lib/controllers/auth_controller.dart`

```dart
Future<bool> login(String email, String password) async {
  try {
    isLoading.value = true;

    final response = await _apiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    // Save token
    await _apiService.saveToken(response['token']);

    // Save user data
    final user = User.fromJson(response['user']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));

    currentUser.value = user;
    
    Get.offAllNamed(Routes.HOME);
    Get.snackbar('Sukses', 'Selamat datang, ${user.name}!');
    
    return true;
  } catch (e) {
    Get.snackbar('Error', 'Login gagal: ${e.toString()}');
    return false;
  } finally {
    isLoading.value = false;
  }
}

Future<bool> register(String name, String email, String password) async {
  try {
    isLoading.value = true;

    final response = await _apiService.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    // Save token
    await _apiService.saveToken(response['token']);

    // Save user data
    final user = User.fromJson(response['user']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));

    currentUser.value = user;
    
    Get.offAllNamed(Routes.HOME);
    Get.snackbar('Sukses', 'Akun berhasil dibuat!');
    
    return true;
  } catch (e) {
    Get.snackbar('Error', 'Registrasi gagal: ${e.toString()}');
    return false;
  } finally {
    isLoading.value = false;
  }
}
```

### 3. Update Book Controller

File: `lib/controllers/book_controller.dart`

```dart
// Load books from API
Future<void> loadBooks() async {
  try {
    isLoading.value = true;
    
    final response = await Get.find<ApiService>().get('/books');
    
    allBooks.value = (response['data'] as List)
        .map((json) => Book.fromJson(json))
        .toList();
    
    filteredBooks.value = allBooks;
    
  } catch (e) {
    Get.snackbar('Error', 'Gagal memuat buku: ${e.toString()}');
  } finally {
    isLoading.value = false;
  }
}

// Load book detail
Future<Book?> loadBookDetail(String bookId) async {
  try {
    final response = await Get.find<ApiService>().get('/books/$bookId');
    return Book.fromJson(response['data']);
  } catch (e) {
    Get.snackbar('Error', 'Gagal memuat detail buku: ${e.toString()}');
    return null;
  }
}

// Load chapters
Future<List<Chapter>> loadChapters(String bookId) async {
  try {
    final response = await Get.find<ApiService>().get('/books/$bookId/chapters');
    return (response['data'] as List)
        .map((json) => Chapter.fromJson(json))
        .toList();
  } catch (e) {
    Get.snackbar('Error', 'Gagal memuat chapter: ${e.toString()}');
    return [];
  }
}

// Search books
Future<void> searchBooksAPI(String query) async {
  try {
    if (query.isEmpty) {
      filteredBooks.value = allBooks;
      return;
    }
    
    final response = await Get.find<ApiService>().get('/books/search?q=$query');
    
    filteredBooks.value = (response['data'] as List)
        .map((json) => Book.fromJson(json))
        .toList();
        
  } catch (e) {
    Get.snackbar('Error', 'Pencarian gagal: ${e.toString()}');
  }
}
```

### 4. Create Book Service

File: `lib/services/book_service.dart`

```dart
import 'package:get/get.dart';
import '../models/book.dart';
import 'api_service.dart';

class BookService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Book>> getAllBooks() async {
    final response = await _api.get('/books');
    return (response['data'] as List)
        .map((json) => Book.fromJson(json))
        .toList();
  }

  Future<Book> getBookById(String id) async {
    final response = await _api.get('/books/$id');
    return Book.fromJson(response['data']);
  }

  Future<List<Book>> searchBooks(String query) async {
    final response = await _api.get('/books/search?q=$query');
    return (response['data'] as List)
        .map((json) => Book.fromJson(json))
        .toList();
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    final response = await _api.get('/books/category/$category');
    return (response['data'] as List)
        .map((json) => Book.fromJson(json))
        .toList();
  }

  Future<void> addToFavorites(String bookId) async {
    await _api.post('/user/favorites/$bookId', {});
  }

  Future<void> removeFromFavorites(String bookId) async {
    await _api.delete('/user/favorites/$bookId');
  }
}
```

## 📝 Expected API Response Format

### Login Response
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "name": "John Doe",
    "email": "john@example.com",
    "photoUrl": null,
    "readingHistory": [],
    "favorites": []
  }
}
```

### Books List Response
```json
{
  "success": true,
  "data": [
    {
      "id": "book_1",
      "title": "Book Title",
      "author": "Author Name",
      "description": "Book description...",
      "coverUrl": "https://example.com/cover.jpg",
      "category": "Fiksi",
      "pages": 250,
      "rating": 4.5,
      "totalReaders": 1500,
      "isPublic": true,
      "publishedDate": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 120
  }
}
```

### Book Detail Response
```json
{
  "success": true,
  "data": {
    "id": "book_1",
    "title": "Book Title",
    "author": "Author Name",
    "description": "Full description...",
    "coverUrl": "https://example.com/cover.jpg",
    "category": "Fiksi",
    "pages": 250,
    "rating": 4.5,
    "totalReaders": 1500,
    "isPublic": true,
    "publishedDate": "2024-01-01T00:00:00Z",
    "chapters": [
      {
        "id": "chapter_1",
        "title": "Chapter 1: Beginning",
        "content": "<h2>Chapter 1</h2><p>Content...</p>",
        "chapterNumber": 1
      }
    ]
  }
}
```

## 🔐 Authentication Flow

1. User login/register
2. Backend returns JWT token
3. Save token to SharedPreferences
4. Include token in all subsequent requests
5. On 401 response, logout user
6. Redirect to login page

## 🚀 Testing API

### Using Postman/Thunder Client

1. **Test Login**
```
POST http://your-api.com/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

2. **Test Get Books**
```
GET http://your-api.com/api/books
Authorization: Bearer YOUR_TOKEN_HERE
```

3. **Test Book Detail**
```
GET http://your-api.com/api/books/book_1
Authorization: Bearer YOUR_TOKEN_HERE
```

## 🎯 Migration Checklist

- [ ] Setup backend API
- [ ] Update baseUrl in ApiService
- [ ] Implement all API endpoints
- [ ] Test authentication flow
- [ ] Test book CRUD operations
- [ ] Implement error handling
- [ ] Add loading states
- [ ] Test offline behavior
- [ ] Add retry mechanism
- [ ] Implement caching

## 📱 Best Practices

1. **Error Handling**
   - Always wrap API calls in try-catch
   - Show user-friendly error messages
   - Log errors for debugging

2. **Loading States**
   - Show loading indicator during API calls
   - Disable buttons while loading
   - Prevent multiple simultaneous requests

3. **Caching**
   - Cache book list locally
   - Update cache periodically
   - Use stale-while-revalidate pattern

4. **Security**
   - Store tokens securely
   - Use HTTPS only
   - Implement token refresh
   - Validate all inputs

5. **Performance**
   - Implement pagination
   - Lazy load images
   - Compress API responses
   - Use CDN for static assets

---

Selamat mengintegrasikan! 🎉