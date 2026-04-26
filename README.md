# InterCommerce App - MVP

Este es un MVP de una aplicación de E-commerce, desarrollada en Flutter siguiendo principios de Clean Architecture.

## 🚀 Arquitectura y Patrones

La aplicación está diseñada bajo el estándar de **Clean Architecture**, dividiendo el código en tres capas principales para garantizar el desacoplamiento y la testabilidad:

- **Domain (Capa de Negocio):** Contiene las Entidades puras, las interfaces de los Repositorios y los Casos de Uso (Usecases). Aquí reside la lógica de cálculo del carrito (impuestos y totales) de forma agnóstica a la infraestructura.
- **Data (Capa de Infraestructura):** Implementaciones de los repositorios, modelos (con **Freezed** para inmutabilidad) y fuentes de datos (Remote via **Dio** y Local via **SQLite**).
- **Presentation (Capa de UI):** Implementada con **Riverpod** (usando Generadores) para la gestión de estados asíncronos y **GoRouter** para una navegación avanzada.

## Instrucciones de Ejecución

1. **Clonar el repositorio.**
2. **Instalar dependencias:**

   ```bash
   flutter pub get
   flutter run
   ```

3. **Ejecutar la aplicación:**

   ```bash
   flutter run
   ```

4. **Ejecutar las pruebas:**

   ```bash
   flutter test
   ```

## Supuestos Técnicos Asumidos

Se asume que la API de DummyJSON es la única fuente de verdad para los datos remotos.

La persistencia local del catálogo actúa como un mecanismo de "Cache-then-Network" para mejorar la experiencia offline.

El IVA aplicado en el carrito es del 19% (basado en el contexto local del desarrollador).

El feedback táctil se implementó mediante HapticFeedback.lightImpact() para interacciones críticas.

---

### Tecnologías Principales

- **Estado:** Riverpod (AsyncNotifier)
- **Navegación:** GoRouter
- **Persistencia:** SQLite (sqflite)
- **Networking:** Dio
- **Diseño:** Material 3 con Slivers y Shimmer effects.

### Gestión Centralizada de Errores

Se implementó un sistema de gestión de errores basado en la capa `core`, donde:

- Los errores de infraestructura (Dio, SQLite) se mapean a clases `Failure` de dominio.
- Se utiliza un `Interceptor` en el cliente HTTP para capturar fallos de red globalmente.
- La UI reacciona de forma reactiva mediante los estados `AsyncError` de Riverpod, permitiendo reintentos limpios del flujo de datos.

## Estructura General

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
