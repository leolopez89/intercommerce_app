# intercommerce_app

An e-commerce app

## General Stucture

```txt
    lib/
    ├── core/                 # Errores, utilidades, constantes, temas
    ├── features/
    │   ├── catalog/          # Módulo A
    │   │   ├── data/         # Models, Repositories Impl, Datasources
    │   │   ├── domain/       # Entities, Repository Interfaces, UseCases
    │   │   └── presentation/ # Widgets, Providers (Riverpod), Screens
    │   ├── product_detail/   # Módulo B
    │   └── cart/             # Módulo C
    └── main.dart
```

```txt
lib/
├── core/
│   ├── errors/
│   │   └── exceptions.dart
│   ├── utils/
│   │   └── constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── di/
│       └── injector.dart
│
├── features/
│   ├── catalog/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── product_api.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository_impl.dart   # implementación
│   │   │   └── mappers/
│   │   │       └── product_mapper.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart        # interface
│   │   │   └── usecases/
│   │   │       ├── get_products_paginated.dart
│   │   │       ├── search_products.dart
│   │   │       └── cache_products_offline.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── product_provider.dart          # provider Riverpod
│   │       ├── pages/
│   │       │   └── catalog_page.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           └── shimmer_loader.dart
│   │
│   ├── product_detail/
│   │   ├── data/
│   │   │   └── product_detail_api.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product_detail.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_detail_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_product_detail.dart
│   │   │       └── add_product_to_cart.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── product_detail_provider.dart
│   │       ├── pages/
│   │       │   └── product_detail_page.dart
│   │       └── widgets/
│   │           └── product_detail_view.dart
│   │
│   └── cart/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── cart_db.dart
│       │   ├── repositories/
│       │   │   └── cart_repository_impl.dart
│       │   └── mappers/
│       │       └── cart_mapper.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── cart_item.dart
│       │   ├── repositories/
│       │   │   └── cart_repository.dart
│       │   └── usecases/
│       │       ├── add_product_to_cart.dart
│       │       ├── remove_product_from_cart.dart
│       │       ├── calculate_cart_total.dart
│       │       ├── persist_cart.dart
│       │       └── load_cart.dart
│       └── presentation/
│           ├── providers/
│           │   └── cart_provider.dart
│           ├── pages/
│           │   └── cart_page.dart
│           └── widgets/
│               └── cart_item_tile.dart
│
└── main.dart
```
