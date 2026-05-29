# cep_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
cep_app
├─ .metadata
├─ README.md
├─ analysis_options.yaml
├─ android
├─ assets
│  └─ fonts
│     └─ Poppins-Regular.ttf
├─ ios
├─ lib
│  ├─ features
│  │  └─ cep
│  │     ├─ data
│  │     │  ├─ data_sources
│  │     │  │  ├─ const
│  │     │  │  │  └─ get_cep_error_messages.dart
│  │     │  │  ├─ erros
│  │     │  │  │  └─ cep_exceptions.dart
│  │     │  │  ├─ local
│  │     │  │  │  ├─ get_cep_details_by_cep_local_data_source.dart
│  │     │  │  │  └─ get_cep_details_by_local_details_local_data_source.dart
│  │     │  │  └─ remote
│  │     │  │     ├─ get_cep_details_by_cep_remote_data_source.dart
│  │     │  │     └─ get_cep_details_by_local_details_remote_data_source.dart
│  │     │  ├─ models
│  │     │  │  └─ cep_response_model.dart
│  │     │  └─ repositories
│  │     │     └─ cep_repository_impl.dart
│  │     ├─ domain
│  │     │  ├─ entities
│  │     │  │  ├─ cep_response.dart
│  │     │  │  ├─ get_cep_details_by_cep_body.dart
│  │     │  │  └─ get_ceps_details_by_local_details_body.dart
│  │     │  ├─ errors
│  │     │  │  └─ cep_exception.dart
│  │     │  ├─ providers
│  │     │  │  └─ get_cep_details_provider.dart
│  │     │  ├─ repositories
│  │     │  │  └─ cep_repository.dart
│  │     │  └─ use_cases
│  │     │     ├─ get_cep_details_by_cep.dart
│  │     │     └─ get_ceps_details_by_local_details.dart
│  │     └─ presentation
│  │        ├─ constants
│  │        │  └─ validation_messages_const.dart
│  │        ├─ mixins
│  │        │  ├─ cep_tec_mixin.dart
│  │        │  └─ search_cep_local_details_mixin.dart
│  │        ├─ riverpod
│  │        │  ├─ base_cep_app_state.dart
│  │        │  ├─ search_by_cep_riverpod.dart
│  │        │  │  ├─ cep_notifier_provider.dart
│  │        │  │  ├─ search_by_cep_notifier.dart
│  │        │  │  └─ search_by_cep_state.dart
│  │        │  └─ search_by_local_details_riverpod
│  │        │     ├─ local_details_notifier_provider.dart
│  │        │     ├─ search_by_local_details_notifier.dart
│  │        │     └─ search_by_local_details_state.dart
│  │        ├─ screens
│  │        │  └─ cep_screen.dart
│  │        └─ widgets
│  │           ├─ app_bar
│  │           │  └─ cep_screen_app_bar_widget.dart
│  │           ├─ buttons
│  │           │  └─ cep_button_widget.dart
│  │           ├─ inputs
│  │           │  └─ cep_text_field_widget.dart
│  │           ├─ no_result_widget
│  │           │  └─ no_result_widget.dart
│  │           └─ tabs
│  │              ├─ search_by_cep_tab_widget.dart
│  │              └─ search_by_local_details_tab_widget.dart
│  ├─ main.dart
│  └─ shared
│     ├─ const
│     │  └─ const_strings.dart
│     ├─ data
│     │  ├─ async
│     │  │  └─ either.dart
│     │  ├─ local
│     │  │  ├─ errors
│     │  │  │  └─ local_exception.dart
│     │  │  └─ local_service
│     │  │     ├─ local_service.dart
│     │  │     └─ shared_preferences_service.dart
│     │  ├─ models
│     │  │  ├─ api_base_model.dart
│     │  │  └─ api_response_model.dart
│     │  └─ remote
│     │     ├─ api_service.dart
│     │     ├─ dio_service.dart
│     │     └─ errors
│     │        ├─ api_exception.dart
│     │        └─ no_internet_exception.dart
│     ├─ domain
│     │  └─ providers
│     │     ├─ api_provider.dart
│     │     └─ local_provider.dart
│     ├─ erros
│     │  └─ base_exceptions.dart
│     ├─ main
│     │  ├─ cep_app.dart
│     │  └─ cep_config.dart
│     └─ ui
│        ├─ cep_app_colors.dart
│        ├─ extensions
│        │  ├─ snack_bar_extension.dart
│        │  └─ theme_extension.dart
│        └─ theme
│           ├─ cep_app_theme.dart
│           ├─ data
│           │  ├─ datasources
│           │  │  ├─ get_theme_local_datasource.dart
│           │  │  └─ set_theme_local_datasource.dart
│           │  └─ repositories
│           │     └─ theme_repository_impl.dart
│           ├─ domain
│           │  ├─ providers
│           │  │  ├─ theme_notifier.dart
│           │  │  ├─ theme_notifier_provider.dart
│           │  │  └─ theme_state.dart
│           │  └─ repositories
│           │     └─ theme_repository.dart
│           └─ errors
│              └─ theme_local_exception.dart
├─ pubspec.lock
├─ pubspec.yaml
└─ test
   ├─ features
   │  └─ cep
   │     ├─ data
   │     │  ├─ data_sources
   │     │  │  ├─ local
   │     │  │  │  └─ get_cep_details_by_cep_local_data_source_test.dart
   │     │  │  └─ remote
   │     │  │     └─ get_cep_details_by_cep_remote_data_source_test.dart
   │     │  ├─ models
   │     │  │  └─ cep_response_model_test.dart
   │     │  └─ repositories
   │     │     └─ cep_repository_impl_test.dart
   │     ├─ domain
   │     │  ├─ providers
   │     │  │  └─ get_cep_details_provider_test.dart
   │     │  └─ use_cases
   │     │     ├─ get_cep_details_by_cep_test.dart
   │     │     └─ get_ceps_details_by_local_details_test.dart
   │     └─ presentation
   │        ├─ riverpod
   │        │  ├─ search_by_cep_riverpod.dart
   │        │  │  └─ search_by_cep_notifier_test.dart
   │        │  └─ search_by_local_details_riverpod
   │        │     └─ search_by_local_details_notifier_test.dart
   │        └─ widgets
   │           └─ tabs
   │              ├─ search_by_cep_tab_widget_test.dart
   │              └─ search_by_local_details_tab_widget_test.dart
   └─ fixtures
      ├─ cep_fixtures.dart
      └─ mock_cep_repository.dart

```