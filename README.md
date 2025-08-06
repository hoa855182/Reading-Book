# AMG Management Flutter - Project Structure Guide

## Tổng quan

Đây là một dự án Flutter sử dụng **Clean Architecture** với **GetX** làm state management. Dự án được thiết kế theo mô hình 3-layer architecture để tách biệt rõ ràng giữa Presentation, Domain và Data layers, với tổ chức theo **Feature-based** structure.

### Kiến trúc tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │ Controllers │ │    Pages    │ │   Widgets   │           │
│  │   (GetX)    │ │  (Screens)  │ │ (Reusable)  │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Bindings   │ │   Routes    │ │ Middlewares │           │
│  │   (DI)      │ │ (Navigation)│ │ (Guards)    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Entities   │ │Repositories │ │  Use Cases  │           │
│  │ (Models)    │ │(Interfaces) │ │(Business)   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Models    │ │Repositories │ │  Providers  │           │
│  │ (DTOs)      │ │(Implementation)│ (API/DB)   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Network   │ │   APIs      │ │  Services   │           │
│  │ (HTTP/Dio)  │ │(Endpoints)  │ │(External)   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## Cấu trúc thư mục chi tiết

```
amg_management_flutter/
├── lib/                           # Thư mục chứa mã nguồn chính
│   ├── main.dart                  # Điểm khởi đầu của ứng dụng
│   ├── app/                       # Core application logic
│   │   ├── core/                  # Core business logic & exceptions
│   │   │   ├── exceptions/        # Custom exceptions
│   │   │   └── results/           # Result types (Success/Failure)
│   │   ├── config/                # Cấu hình ứng dụng
│   │   │   ├── app_constants.dart # Constants toàn cục
│   │   │   ├── app_colors.dart    # Định nghĩa màu sắc
│   │   │   ├── app_text_styles.dart # Định nghĩa text styles
│   │   │   └── app_images.dart    # Định nghĩa image paths
│   │   ├── services/              # Global services
│   │   │   ├── local_storage.dart # Local storage service
│   │   │   └── token_manager.dart # Token management
│   │   ├── util/                  # Utility functions
│   │   ├── extensions/            # Dart extensions
│   │   ├── helpers/               # Helper classes
│   │   └── theme/                 # Theme configuration
│   ├── data/                      # Data layer
│   │   ├── models/                # Data models (DTOs)
│   │   │   └── user/              # User-related models
│   │   └── providers/             # Data providers
│   │       ├── repositories/      # Repository implementations
│   │       └── network/           # Network layer
│   │           ├── api_provider.dart      # HTTP client setup
│   │           ├── api_endpoint.dart      # API endpoints
│   │           ├── api_request_representable.dart # Request interface
│   │           └── apis/          # Feature-based API modules
│   │               ├── auth/      # Authentication APIs
│   │               │   ├── auth_api.dart
│   │               │   ├── login_request.dart
│   │               │   └── reset_password_request.dart
│   │               └── [feature]/ # Other feature APIs
│   ├── domain/                    # Domain layer
│   │   ├── models/                # Domain entities
│   │   ├── repositories/          # Repository interfaces
│   │   │   ├── auth_repository.dart
│   │   │   └── home_repository.dart
│   │   ├── usecases/              # Business use cases
│   │   └── services/              # Domain services
│   ├── presentations/             # Presentation layer (Feature-based)
│   │   ├── app.dart               # App widget chính
│   │   ├── controllers/           # GetX controllers (by feature)
│   │   │   ├── auth/              # Authentication controllers
│   │   │   │   ├── auth_controller.dart
│   │   │   │   └── auth_binding.dart
│   │   │   ├── home/              # Home controllers
│   │   │   ├── settings/          # Settings controllers
│   │   │   ├── calendar/          # Calendar controllers
│   │   │   ├── admin/             # Admin controllers
│   │   │   ├── reset_pass/        # Reset password controllers
│   │   │   ├── nav_wrapper/       # Navigation controllers
│   │   │   └── app/               # App-level controllers
│   │   ├── pages/                 # UI pages/screens (by feature)
│   │   │   ├── auth/              # Authentication pages
│   │   │   │   ├── login_page.dart
│   │   │   │   └── school_register_page.dart
│   │   │   ├── home/              # Home pages
│   │   │   ├── settings/          # Settings pages
│   │   │   ├── calendar/          # Calendar pages
│   │   │   ├── admin/             # Admin pages
│   │   │   ├── reset_pass/        # Reset password pages
│   │   │   ├── nav_wrapper/       # Navigation pages
│   │   │   └── splash_screen.dart # Splash screen
│   │   ├── widgets/               # Reusable widgets
│   │   ├── routes/                # Route definitions
│   │   │   ├── app_routes.dart    # Route constants
│   │   │   └── app_pages.dart     # GetPages configuration
│   │   └── middlewares/           # Route middlewares
│   └── l10n/                      # Internationalization
│       ├── app_en.arb             # English translations
│       └── app_vi.arb             # Vietnamese translations
├── assets/                        # Tài nguyên tĩnh
│   ├── images/                    # Hình ảnh
│   ├── icons/                     # Icons
│   └── env/                       # Environment files
│       └── .env_dev               # Development environment
├── test/                          # Unit tests
├── android/                       # Android specific code
├── ios/                          # iOS specific code
├── web/                          # Web specific code
├── windows/                      # Windows specific code
├── linux/                        # Linux specific code
├── macos/                        # macOS specific code
├── pubspec.yaml                  # Dependencies & configuration
├── pubspec.lock                  # Locked dependency versions
├── analysis_options.yaml         # Dart analyzer configuration
└── README.md                     # Project documentation
```

## Mô tả chi tiết từng layer

### 1. Presentation Layer (`lib/presentations/`)

**Mục đích**: Xử lý UI và tương tác với người dùng

#### Feature-based Organization:

Mỗi feature được tổ chức thành một thư mục riêng biệt chứa:

- **`controllers/`**: GetX controllers quản lý state và business logic cho UI
- **`pages/`**: Các màn hình chính của ứng dụng
- **`bindings/`**: Dependency injection cho từng feature
- **`widgets/`**: Các widget có thể tái sử dụng
- **`routes/`**: Định nghĩa routing và navigation
- **`middlewares/`**: Middleware cho route (auth, permissions, etc.)

#### Ví dụ cấu trúc feature Auth:

```
presentations/
├── controllers/auth/
│   ├── auth_controller.dart    # Business logic
│   └── auth_binding.dart       # Dependency injection
├── pages/auth/
│   ├── login_page.dart         # Login screen
│   └── school_register_page.dart # Register screen
└── widgets/auth/
    └── login_form.dart         # Reusable login form
```

### 2. Domain Layer (`lib/domain/`)

**Mục đích**: Chứa business logic và rules

- **`entities/`**: Domain objects, không phụ thuộc vào framework
- **`repositories/`**: Interface định nghĩa contract cho data access
- **`usecases/`**: Business logic, orchestrate entities và repositories
- **`services/`**: Domain services

### 3. Data Layer (`lib/data/`)

**Mục đích**: Xử lý data access và external services

- **`models/`**: Data models (DTOs - Data Transfer Objects)
- **`providers/repositories/`**: Implementation của repository interfaces
- **`providers/network/`**: Network layer với feature-based API organization

### 4. App Core (`lib/app/`)

**Mục đích**: Shared utilities và core functionality

- **`core/`**: Core business logic, exceptions, và result types
- **`config/`**: Cấu hình ứng dụng (constants, colors, styles, images)
- **`services/`**: Global services (local storage, token management)
- **`util/`**: Utility functions
- **`extensions/`**: Dart extensions
- **`helpers/`**: Helper classes
- **`theme/`**: Theme configuration

## API Setup và Network Layer

### 1. HTTP Client Setup (`lib/data/providers/network/api_provider.dart`)

```dart
class APIProvider {
  late Dio _dio;
  static final APIProvider _instance = APIProvider._internal();

  factory APIProvider() {
    return _instance;
  }

  APIProvider._internal() {
    _dio = Dio();
    _dio.options.receiveTimeout = const Duration(seconds: 60);

    // Add interceptors for authentication
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        String? accessToken = await TokenManager().getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // Handle authentication error
        }
        return handler.next(e);
      },
    ));

    // Add logging interceptors
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      compact: true,
    ));
  }

  Future<T?> request<T extends dynamic>(APIRequestRepresentable request) async {
    try {
      final Response<T> response = await _dio.request(
        request.url,
        options: Options(method: request.method.string, headers: request.headers),
        queryParameters: request.query,
        data: request.body,
      );
      return response.data;
    } on DioException catch (e) {
      // Handle different types of errors
      throw APIResponseException(
        e.response?.data['detail'] ?? "Unknown error",
        response: e.response,
        code: e.response?.statusCode,
      );
    }
  }
}
```

### 2. API Request Interface (`lib/data/providers/network/api_request_representable.dart`)

```dart
abstract class APIRequestRepresentable {
  String get endpoint;
  HTTPMethod get method;
  Map<String, dynamic>? get query;
  dynamic get body;
  String get baseUrl;
  String get url => baseUrl + endpoint;
  Map<String, String>? get headers => null;

  Future<Either<Failure, T>> request<T>();
}

enum HTTPMethod { get, post, put, delete, patch }
```

### 3. Feature-based API Organization

#### Cấu trúc thư mục:

```
lib/data/providers/network/apis/
├── auth/
│   ├── auth_api.dart              # API methods
│   ├── login_request.dart         # Login request implementation
│   └── reset_password_request.dart # Reset password request
├── home/
│   ├── home_api.dart
│   └── dashboard_request.dart
└── [other_features]/
```

#### Ví dụ Auth API (`lib/data/providers/network/apis/auth/auth_api.dart`):

```dart
class AuthAPI {
  static Future<Either<Failure, dynamic>> loginRequest({
    required String phoneNumber,
    required String password,
  }) =>
      LoginRequest(
        phoneNumber: phoneNumber,
        password: password,
      ).request();

  static Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  }) =>
      ResetPassRequest(
        phoneNumber: phoneNumber,
      ).request();
}
```

#### Ví dụ Login Request (`lib/data/providers/network/apis/auth/login_request.dart`):

```dart
class LoginRequest extends APIRequestRepresentable {
  final String phoneNumber;
  final String password;

  const LoginRequest({
    required this.phoneNumber,
    required this.password,
  });

  @override
  String get endpoint => APIEndpoint.login;

  @override
  HTTPMethod get method => HTTPMethod.post;

  @override
  get body {
    return {
      "userId": phoneNumber,
      "userPassword": password,
    };
  }

  @override
  String get baseUrl => BaseUrls.baseUrl;

  @override
  Future<Either<Failure, UserModel>> request() async {
    try {
      final response = await APIProvider().request(this);
      if (response != null) {
        final UserModel data = UserModel.fromJson(response);
        return Right(data);
      } else {
        return Left(SystemFailure(message: "Đăng nhập thất bại"));
      }
    } catch (e) {
      return const Left(SystemFailure(message: "Đăng nhập thất bại"));
    }
  }
}
```

## Repository Pattern Implementation

### 1. Repository Interface (Domain Layer)

```dart
// lib/domain/repositories/auth_repository.dart
abstract class AuthenticationRepository {
  Future<Either<Failure, dynamic>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  });
}
```

### 2. Repository Implementation (Data Layer)

```dart
// lib/data/providers/repositories/auth_repository_impl.dart
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthAPI _authAPI;

  AuthenticationRepositoryImpl(this._authAPI);

  @override
  Future<Either<Failure, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    return await _authAPI.loginRequest(
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  @override
  Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  }) async {
    return await _authAPI.resetPassRequest(
      phoneNumber: phoneNumber,
    );
  }
}
```

### 3. Data Flow

```
Controller → Repository Interface → Repository Implementation → API → Network
     ↑                                                              ↓
     └────────────────── Response Data ────────────────────────────┘
```

## Feature-based Organization

### 1. Cấu trúc Feature

Mỗi feature được tổ chức thành một module hoàn chỉnh:

```
feature_name/
├── controllers/
│   ├── feature_controller.dart    # Business logic
│   └── feature_binding.dart       # Dependency injection
├── pages/
│   ├── feature_list_page.dart     # List screen
│   ├── feature_detail_page.dart   # Detail screen
│   └── feature_form_page.dart     # Form screen
├── widgets/
│   ├── feature_card.dart          # Reusable components
│   └── feature_form.dart
└── models/
    └── feature_model.dart         # Feature-specific models
```

### 2. Dependency Injection với GetX Bindings

```dart
// lib/presentations/controllers/auth/auth_binding.dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<ApiService>(() => ApiService());

    // Controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<AuthController>(
      () => AuthController(
        appController: Get.find<AppController>(),
        authenticationRepository: Get.find<AuthenticationRepository>(),
      ),
    );
  }
}
```

### 3. Controller Pattern

```dart
// lib/presentations/controllers/auth/auth_controller.dart
class AuthController extends GetxController {
  final AppController appController;
  final AuthenticationRepository authenticationRepository;

  AuthController({
    required this.appController,
    required this.authenticationRepository,
  });

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> login(String phoneNumber, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await authenticationRepository.login(
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (user) {
        // Handle success
        appController.setUser(user);
        Get.offAllNamed(Routes.home);
        isLoading.value = false;
      },
    );
  }
}
```

## Routing và Navigation

### 1. Route Constants (`lib/presentations/routes/app_routes.dart`)

```dart
abstract class Routes {
  static String root = "/";
  static const String login = '/login';
  static const String home = '/home';
  static const String selectBranch = '/select-branch';
  static const String resetPassword = '/reset-password';
  static const String schoolRegister = '/school-register';
  static const String userSettings = '/user-settings';
  static const String changePassword = '/change-password';
  static const String changeAvatar = '/change-avatar';
  static const String userGuide = '/user-guide';
  static const String splashScreen = '/splash';
  static String navWrapper = "/nav-wrapper";
  static String calendar = "/calendar";
}
```

### 2. GetPages Configuration (`lib/presentations/routes/app_pages.dart`)

```dart
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.root,
      middlewares: [RedirectMiddleware()],
      page: () => Container(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.selectBranch,
      page: () => SelectBranchView(),
      binding: AdminBinding(),
    ),
    // ... other routes
  ];
}
```

### 3. Navigation Usage

```dart
// Navigate to a new page
Get.toNamed(Routes.login);

// Navigate and replace current page
Get.offNamed(Routes.home);

// Navigate and clear all previous pages
Get.offAllNamed(Routes.home);

// Navigate with parameters
Get.toNamed(Routes.userDetail, arguments: {'userId': 123});

// Navigate with parameters and prevent back
Get.offAllNamed(Routes.home, arguments: {'fromLogin': true});

// Go back
Get.back();

// Go back with result
Get.back(result: 'success');
```

### 4. Route Middleware

```dart
// lib/presentations/middlewares/redirect_middleware.dart
class RedirectMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check authentication status
    final isAuthenticated = Get.find<LocalStorageService>().isLoggedIn;

    if (!isAuthenticated && route != Routes.login) {
      return const RouteSettings(name: Routes.login);
    }

    if (isAuthenticated && route == Routes.login) {
      return const RouteSettings(name: Routes.home);
    }

    return null;
  }
}
```

### 1. HTTP Client Setup (`lib/data/providers/network/api_provider.dart`)

```dart
class APIProvider {
  late Dio _dio;
  static final APIProvider _instance = APIProvider._internal();

  factory APIProvider() {
    return _instance;
  }

  APIProvider._internal() {
    _dio = Dio();
    _dio.options.receiveTimeout = const Duration(seconds: 60);

    // Add interceptors for authentication
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        String? accessToken = await TokenManager().getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // Handle authentication error
        }
        return handler.next(e);
      },
    ));

    // Add logging interceptors
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      compact: true,
    ));
  }

  Future<T?> request<T extends dynamic>(APIRequestRepresentable request) async {
    try {
      final Response<T> response = await _dio.request(
        request.url,
        options: Options(method: request.method.string, headers: request.headers),
        queryParameters: request.query,
        data: request.body,
      );
      return response.data;
    } on DioException catch (e) {
      // Handle different types of errors
      throw APIResponseException(
        e.response?.data['detail'] ?? "Unknown error",
        response: e.response,
        code: e.response?.statusCode,
      );
    }
  }
}
```

### 2. API Request Interface (`lib/data/providers/network/api_request_representable.dart`)

```dart
abstract class APIRequestRepresentable {
  String get endpoint;
  HTTPMethod get method;
  Map<String, dynamic>? get query;
  dynamic get body;
  String get baseUrl;
  String get url => baseUrl + endpoint;
  Map<String, String>? get headers => null;

  Future<Either<Failure, T>> request<T>();
}

enum HTTPMethod { get, post, put, delete, patch }
```

### 3. Feature-based API Organization

#### Cấu trúc thư mục:

```
lib/data/providers/network/apis/
├── auth/
│   ├── auth_api.dart              # API methods
│   ├── login_request.dart         # Login request implementation
│   └── reset_password_request.dart # Reset password request
├── home/
│   ├── home_api.dart
│   └── dashboard_request.dart
└── [other_features]/
```

#### Ví dụ Auth API (`lib/data/providers/network/apis/auth/auth_api.dart`):

```dart
class AuthAPI {
  static Future<Either<Failure, dynamic>> loginRequest({
    required String phoneNumber,
    required String password,
  }) =>
      LoginRequest(
        phoneNumber: phoneNumber,
        password: password,
      ).request();

  static Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  }) =>
      ResetPassRequest(
        phoneNumber: phoneNumber,
      ).request();
}
```

#### Ví dụ Login Request (`lib/data/providers/network/apis/auth/login_request.dart`):

```dart
class LoginRequest extends APIRequestRepresentable {
  final String phoneNumber;
  final String password;

  const LoginRequest({
    required this.phoneNumber,
    required this.password,
  });

  @override
  String get endpoint => APIEndpoint.login;

  @override
  HTTPMethod get method => HTTPMethod.post;

  @override
  get body {
    return {
      "userId": phoneNumber,
      "userPassword": password,
    };
  }

  @override
  String get baseUrl => BaseUrls.baseUrl;

  @override
  Future<Either<Failure, UserModel>> request() async {
    try {
      final response = await APIProvider().request(this);
      if (response != null) {
        final UserModel data = UserModel.fromJson(response);
        return Right(data);
      } else {
        return Left(SystemFailure(message: "Đăng nhập thất bại"));
      }
    } catch (e) {
      return const Left(SystemFailure(message: "Đăng nhập thất bại"));
    }
  }
}
```

## Repository Pattern Implementation

### 1. Repository Interface (Domain Layer)

```dart
// lib/domain/repositories/auth_repository.dart
abstract class AuthenticationRepository {
  Future<Either<Failure, dynamic>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  });
}
```

### 2. Repository Implementation (Data Layer)

```dart
// lib/data/providers/repositories/auth_repository_impl.dart
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthAPI _authAPI;

  AuthenticationRepositoryImpl(this._authAPI);

  @override
  Future<Either<Failure, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    return await _authAPI.loginRequest(
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  @override
  Future<Either<Failure, bool>> resetPassRequest({
    required String phoneNumber,
  }) async {
    return await _authAPI.resetPassRequest(
      phoneNumber: phoneNumber,
    );
  }
}
```

### 3. Data Flow

```
Controller → Repository Interface → Repository Implementation → API → Network
     ↑                                                              ↓
     └────────────────── Response Data ────────────────────────────┘
```

## Feature-based Organization

### 1. Cấu trúc Feature

Mỗi feature được tổ chức thành một module hoàn chỉnh:

```
feature_name/
├── controllers/
│   ├── feature_controller.dart    # Business logic
│   └── feature_binding.dart       # Dependency injection
├── pages/
│   ├── feature_list_page.dart     # List screen
│   ├── feature_detail_page.dart   # Detail screen
│   └── feature_form_page.dart     # Form screen
├── widgets/
│   ├── feature_card.dart          # Reusable components
│   └── feature_form.dart
└── models/
    └── feature_model.dart         # Feature-specific models
```

### 2. Dependency Injection với GetX Bindings

```dart
// lib/presentations/controllers/auth/auth_binding.dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<ApiService>(() => ApiService());

    // Controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<AuthController>(
      () => AuthController(
        appController: Get.find<AppController>(),
        authenticationRepository: Get.find<AuthenticationRepository>(),
      ),
    );
  }
}
```

### 3. Controller Pattern

```dart
// lib/presentations/controllers/auth/auth_controller.dart
class AuthController extends GetxController {
  final AppController appController;
  final AuthenticationRepository authenticationRepository;

  AuthController({
    required this.appController,
    required this.authenticationRepository,
  });

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> login(String phoneNumber, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await authenticationRepository.login(
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (user) {
        // Handle success
        appController.setUser(user);
        Get.offAllNamed(Routes.home);
        isLoading.value = false;
      },
    );
  }
}
```

## Routing và Navigation

### 1. Route Constants (`lib/presentations/routes/app_routes.dart`)

```dart
abstract class Routes {
  static String root = "/";
  static const String login = '/login';
  static const String home = '/home';
  static const String selectBranch = '/select-branch';
  static const String resetPassword = '/reset-password';
  static const String schoolRegister = '/school-register';
  static const String userSettings = '/user-settings';
  static const String changePassword = '/change-password';
  static const String changeAvatar = '/change-avatar';
  static const String userGuide = '/user-guide';
  static const String splashScreen = '/splash';
  static String navWrapper = "/nav-wrapper";
  static String calendar = "/calendar";
}
```

### 2. GetPages Configuration (`lib/presentations/routes/app_pages.dart`)

```dart
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.root,
      middlewares: [RedirectMiddleware()],
      page: () => Container(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.selectBranch,
      page: () => SelectBranchView(),
      binding: AdminBinding(),
    ),
    // ... other routes
  ];
}
```

### 3. Navigation Usage

```dart
// Navigate to a new page
Get.toNamed(Routes.login);

// Navigate and replace current page
Get.offNamed(Routes.home);

// Navigate and clear all previous pages
Get.offAllNamed(Routes.home);

// Navigate with parameters
Get.toNamed(Routes.userDetail, arguments: {'userId': 123});

// Navigate with parameters and prevent back
Get.offAllNamed(Routes.home, arguments: {'fromLogin': true});

// Go back
Get.back();

// Go back with result
Get.back(result: 'success');
```

### 4. Route Middleware

```dart
// lib/presentations/middlewares/redirect_middleware.dart
class RedirectMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check authentication status
    final isAuthenticated = Get.find<LocalStorageService>().isLoggedIn;

    if (!isAuthenticated && route != Routes.login) {
      return const RouteSettings(name: Routes.login);
    }

    if (isAuthenticated && route == Routes.login) {
      return const RouteSettings(name: Routes.home);
    }

    return null;
  }
}
```

## Thêm Feature mới

### 1. Tạo API Layer

```dart
// lib/data/providers/network/apis/user/user_api.dart
class UserAPI {
  static Future<Either<Failure, List<UserModel>>> getUsers() =>
      GetUsersRequest().request();
}

// lib/data/providers/network/apis/user/get_users_request.dart
class GetUsersRequest extends APIRequestRepresentable {
  @override
  String get endpoint => APIEndpoint.users;

  @override
  HTTPMethod get method => HTTPMethod.get;

  @override
  Future<Either<Failure, List<UserModel>>> request() async {
    // Implementation
  }
}
```

### 2. Tạo Repository

```dart
// lib/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Either<Failure, List<UserModel>>> getUsers();
}

// lib/data/providers/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserAPI _userAPI;

  UserRepositoryImpl(this._userAPI);

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    return await _userAPI.getUsers();
  }
}
```

### 3. Tạo Controller

```dart
// lib/presentations/controllers/user/user_controller.dart
class UserController extends GetxController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadUsers() async {
    isLoading.value = true;
    final result = await userRepository.getUsers();
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (userList) => users.assignAll(userList),
    );
    isLoading.value = false;
  }
}
```

### 4. Tạo Binding

```dart
// lib/presentations/controllers/user/user_binding.dart
class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
```

### 5. Tạo Pages

```dart
// lib/presentations/pages/user/user_list_page.dart
class UserListPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(title: Text(user.name));
          },
        );
      }),
    );
  }
}
```

### 6. Thêm Routes

```dart
// lib/presentations/routes/app_routes.dart
abstract class Routes {
  // ... existing routes
  static const String userList = '/user-list';
}

// lib/presentations/routes/app_pages.dart
class AppPages {
  static final pages = [
    // ... existing pages
    GetPage(
      name: Routes.userList,
      page: () => UserListPage(),
      binding: UserBinding(),
    ),
  ];
}
```

## Best Practices

### 1. Error Handling

```dart
// Sử dụng Either<Failure, T> cho error handling
final result = await repository.getData();
result.fold(
  (failure) {
    // Handle error
    Get.snackbar('Error', failure.message);
  },
  (data) {
    // Handle success
    controller.data.value = data;
  },
);
```

### 2. State Management

```dart
// Sử dụng .obs cho reactive state
final RxBool isLoading = false.obs;
final RxList<UserModel> users = <UserModel>[].obs;

// Sử dụng Obx() cho reactive UI
Obx(() => Text(controller.isLoading.value ? 'Loading...' : 'Ready'))
```

### 3. Dependency Injection

```dart
// Register dependencies
Get.lazyPut<Repository>(() => RepositoryImpl());
Get.lazyPut<Controller>(() => Controller(Get.find<Repository>()));

// Use dependencies
final controller = Get.find<Controller>();
```

### 4. Navigation

```dart
// Use route constants
Get.toNamed(Routes.home);

// Pass arguments
Get.toNamed(Routes.userDetail, arguments: {'id': 123});

// Get arguments
final args = Get.arguments as Map<String, dynamic>;
final id = args['id'];
```

## Các file cấu hình quan trọng

### 1. `pubspec.yaml`

```yaml
# Dependencies chính
dependencies:
  flutter: sdk: flutter
  get: ^4.6.6                    # State management & routing
  dio: ^5.4.0                    # HTTP client
  flutter_dotenv: ^5.1.0         # Environment variables
  shared_preferences: ^2.2.3     # Local storage
  json_annotation: ^4.9.0        # JSON serialization
  flutter_secure_storage: ^9.2.2 # Secure storage
  dartz: ^0.10.1                 # Functional programming
  equatable: ^2.0.5              # Value equality
  # ... và nhiều dependencies khác

# Assets
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/env/
```

### 2. `lib/main.dart`

```dart
void main() async {
  await dotenv.load(fileName: "assets/env/.env_dev");
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  DependencyCreator.init();
  runApp(const App());
}

initServices() async {
  debugPrint('starting services ...');
  await Get.putAsync<LocalStorageService>(
    LocalStorageService().init,
    permanent: true,
  );
  debugPrint('All services started...');
}
```

### 3. Environment Configuration

```

```

## Hướng dẫn sử dụng

### 1. Khởi động dự án

```bash
# Cài đặt dependencies
flutter pub get

# Generate localization
flutter gen-l10n

# Chạy ứng dụng
flutter run
```

### 2. Thêm Feature mới

#### Bước 1: Tạo API Layer

```dart
// lib/data/providers/network/apis/user/user_api.dart
class UserAPI {
  static Future<Either<Failure, List<UserModel>>> getUsers() =>
      GetUsersRequest().request();
}

// lib/data/providers/network/apis/user/get_users_request.dart
class GetUsersRequest extends APIRequestRepresentable {
  @override
  String get endpoint => APIEndpoint.users;

  @override
  HTTPMethod get method => HTTPMethod.get;

  @override
  Future<Either<Failure, List<UserModel>>> request() async {
    // Implementation
  }
}
```

#### Bước 2: Tạo Repository

```dart
// lib/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Either<Failure, List<UserModel>>> getUsers();
}

// lib/data/providers/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserAPI _userAPI;

  UserRepositoryImpl(this._userAPI);

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    return await _userAPI.getUsers();
  }
}
```

#### Bước 3: Tạo Controller

```dart
// lib/presentations/controllers/user/user_controller.dart
class UserController extends GetxController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadUsers() async {
    isLoading.value = true;
    final result = await userRepository.getUsers();
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (userList) => users.assignAll(userList),
    );
    isLoading.value = false;
  }
}
```

#### Bước 4: Tạo Binding

```dart
// lib/presentations/controllers/user/user_binding.dart
class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
```

#### Bước 5: Tạo Pages

```dart
// lib/presentations/pages/user/user_list_page.dart
class UserListPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(title: Text(user.name));
          },
        );
      }),
    );
  }
}
```

#### Bước 6: Thêm Routes

```dart
// lib/presentations/routes/app_routes.dart
abstract class Routes {
  // ... existing routes
  static const String userList = '/user-list';
}

// lib/presentations/routes/app_pages.dart
class AppPages {
  static final pages = [
    // ... existing pages
    GetPage(
      name: Routes.userList,
      page: () => UserListPage(),
      binding: UserBinding(),
    ),
  ];
}
```

### 3. Build ứng dụng

```bash
# Build cho Android
flutter build apk

# Build cho iOS
flutter build ios

# Build cho web
flutter build web
```

### 4. Code generation

```bash
# Generate JSON serializable code
dart run build_runner build

# Watch mode cho development
dart run build_runner watch
```

### 5. Internationalization

1. Định nghĩa translations trong `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`
2. Generate: `flutter gen-l10n`
3. Sử dụng trong code:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@override
Widget build(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  return Text(t.otp_sub_title);
}
```

### 6. App Icons

```bash
# Generate app icons
flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons*
```

## Các lệnh thường dùng

```bash
# Clean và rebuild
flutter clean
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Generate code
dart run build_runner build --delete-conflicting-outputs
```

## Best Practices

### 1. Error Handling

```dart
// Sử dụng Either<Failure, T> cho error handling
final result = await repository.getData();
result.fold(
  (failure) {
    // Handle error
    Get.snackbar('Error', failure.message);
  },
  (data) {
    // Handle success
    controller.data.value = data;
  },
);
```

### 2. State Management

```dart
// Sử dụng .obs cho reactive state
final RxBool isLoading = false.obs;
final RxList<UserModel> users = <UserModel>[].obs;

// Sử dụng Obx() cho reactive UI
Obx(() => Text(controller.isLoading.value ? 'Loading...' : 'Ready'))
```

### 3. Dependency Injection

```dart
// Register dependencies
Get.lazyPut<Repository>(() => RepositoryImpl());
Get.lazyPut<Controller>(() => Controller(Get.find<Repository>()));

// Use dependencies
final controller = Get.find<Controller>();
```

### 4. Navigation

```dart
// Use route constants
Get.toNamed(Routes.home);

// Pass arguments
Get.toNamed(Routes.userDetail, arguments: {'id': 123});

// Get arguments
final args = Get.arguments as Map<String, dynamic>;
final id = args['id'];
```

## Troubleshooting

### Lỗi thường gặp

1. **Build runner conflicts**:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Dependencies conflicts**:

   ```bash
   flutter clean
   flutter pub get
   ```

3. **Localization not working**:

   ```bash
   flutter gen-l10n
   ```

4. **GetX controller not found**:

   - Kiểm tra dependency injection trong binding
   - Đảm bảo controller được register với GetX

5. **API request failing**:

   - Kiểm tra network connectivity
   - Verify API endpoints và authentication
   - Check request/response format

6. **Navigation issues**:
   - Verify route constants match GetPage names
   - Check middleware redirects
   - Ensure proper binding registration

---

_Hướng dẫn này được tạo để hỗ trợ phát triển và maintain dự án Flutter theo Clean Architecture pattern với Feature-based organization._
