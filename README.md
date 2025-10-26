# 🎣 Fraud Fishing

<div align="center">
  <img src="Fraud Fishing/Assets.xcassets/FRAUD FISHING-03.imageset/FRAUD FISHING-03.png" alt="Fraud Fishing Logo" width="200"/>
  
  **Una aplicación iOS moderna para detectar, reportar y combatir sitios web fraudulentos**
  
  ![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
  ![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
  ![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-green.svg)
  ![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
</div>

---

## 📱 Descripción General

**Fraud Fishing** es una aplicación iOS innovadora diseñada para empoderar a los usuarios en la lucha contra el fraude digital. La aplicación permite a la comunidad reportar, clasificar y visualizar sitios web fraudulentos como phishing, scams, malware y otras amenazas cibernéticas.

### 🎯 Propósito Principal
- **Detección colaborativa** de fraudes digitales
- **Denuncia ciudadana** de sitios web sospechosos
- **Visualización inteligente** de tendencias
- **Protección comunitaria** contra amenazas online

### ✨ Características Destacadas
- 🔐 **Autenticación segura** con JWT tokens
- 📊 **Dashboard interactivo** con estadísticas en tiempo real
- 📸 **Subida de evidencias** fotográficas
- 🌙 **Modo oscuro** con diseño moderno
- 🔍 **Búsqueda avanzada** de reportes
- 📱 **Interfaz intuitiva** optimizada para iOS

---

## ⚙️ Tecnologías Utilizadas

### 📱 Frontend (iOS)
- **Swift 5.9+** - Lenguaje de programación principal
- **SwiftUI** - Framework de interfaz de usuario declarativa
- **PhotosUI** - Selección y manejo de imágenes
- **Async/Await** - Programación asíncrona moderna

### 🖥️ Backend
- **Node.js (Express)** - Servidor web y API REST
- **MySQL** - Base de datos relacional
- **JWT Authentication** - Autenticación segura con tokens

### 🛠️ Herramientas de Desarrollo
- **Swagger** - Documentación y testing de API
- **ngrok** - Túnel de desarrollo para testing local
- **Xcode 15+** - IDE de desarrollo iOS

---

## 🚀 Funcionalidades Principales

### 🔑 Autenticación y Perfil
- ✅ Registro de usuarios con validación completa
- ✅ Inicio de sesión seguro con tokens JWT
- ✅ Gestión de perfil de usuario
- ✅ Tokens guardados en UserDefaults para persistencia
- ✅ Refresh automático de tokens

### 📝 Sistema de Reportes
- ✅ Reporte de URLs sospechosas con formulario detallado
- ✅ Categorización por tipo de fraude (Phishing, Scam, Malware, etc.)
- ✅ Sistema de etiquetas personalizables
- ✅ Subida de capturas de pantalla como evidencia
- ✅ Descripción detallada del incidente

### 📊 Dashboard y Visualización
- ✅ Dashboard con sitios más reportados
- ✅ Estadísticas en tiempo real
- ✅ Gráficos interactivos de tendencias
- ✅ Filtros por categoría y fecha
- ✅ Vista compacta de reportes

### 🔍 Búsqueda y Navegación
- ✅ Búsqueda avanzada de reportes
- ✅ Filtros por URL, categoría y fecha
- ✅ Navegación intuitiva entre vistas
- ✅ Detalles completos de cada reporte

### 🎨 Experiencia de Usuario
- ✅ Modo oscuro automático
- ✅ Diseño moderno y minimalista
- ✅ Animaciones fluidas
- ✅ Feedback visual en todas las interacciones
- ✅ Accesibilidad optimizada

---

## 🧩 Estructura del Proyecto


```bash
Fraud Fishing/
├── 📱 Views/                    # Interfaces de usuario
│   ├── Components/              # Componentes reutilizables
│   ├── Buscar/                  # Vistas de búsqueda
│   ├── ScreenLogin.swift        # Pantalla de login
│   ├── ScreenRegister.swift     # Pantalla de registro
│   ├── SrceenDashboard.swift    # Dashboard principal
│   ├── ScreenCreateReport.swift # Creación de reportes
│   └── ...
├── 🎮 Controllers/              # Lógica de negocio (MVVM)
│   ├── AuthenticationController.swift
│   ├── DashboardController.swift
│   ├── CreateReportController.swift
│   └── ...
├── 📦 DTOs/                     # Objetos de transferencia de datos
│   ├── LoginDTO.swift
│   ├── ReportDTO.swift
│   ├── UserProfileDTO.swift
│   └── ...
├── 🌐 Networking/               # Capa de red y API
│   ├── HTTPClient.swift         # Cliente HTTP principal
│   ├── HTTPReport.swift         # Endpoints de reportes
│   ├── AuthRequest.swift        # Autenticación
│   └── ...
├── 💾 Storage/                  # Almacenamiento local
│   └── StorageTokens.swift      # Gestión de tokens
├── 🎨 Assets.xcassets/          # Recursos visuales
└── 🔧 Extensions/               # Extensiones de Swift
```

### 📡 Flujo de Comunicación

SwiftUI View → Controller (ObservableObject) → HTTPClient → Backend API
↑                                                           ↓
UserDefaults   ←   StorageTokens   ←   AuthSession   ←   JWT Response

---

## 🧠 Arquitectura

### 🏗️ Patrón MVVM (Model-View-ViewModel)
La aplicación implementa el patrón **MVVM** con las siguientes capas:

- **📱 View (SwiftUI)**: Interfaces de usuario declarativas y reactivas
- **🎮 ViewModel (Controllers)**: Lógica de negocio con `ObservableObject`
- **📦 Model (DTOs)**: Estructuras de datos y modelos de dominio
- **🌐 Network Layer**: Comunicación con API REST del backend

### 🔄 Gestión de Estado
- **Combine Framework** para programación reactiva
- **@StateObject** y **@ObservedObject** para binding de datos
- **@Published** para actualizaciones automáticas de UI
- **UserDefaults** para persistencia local de tokens

---

## 🧪 Pruebas y Testing

### 🔍 Casos de Prueba Principales

#### 1. **Autenticación**
```bash
# Probar registro de usuario
1. Abrir la app
2. Navegar a "Crear cuenta"
3. Completar formulario con datos válidos
4. Verificar redirección al dashboard

# Probar inicio de sesión
1. Usar credenciales válidas
2. Verificar almacenamiento de token
3. Confirmar acceso al dashboard
```

#### 2. **Creación de Reportes**
```bash
# Crear reporte completo
1. Navegar a "Crear Reporte"
2. Ingresar URL sospechosa
3. Seleccionar categoría
4. Añadir descripción detallada
5. Subir imagen de evidencia
6. Enviar reporte
7. Verificar aparición en dashboard
```

#### 3. **Visualización de Imágenes**
```bash
# Verificar carga de imágenes
1. Abrir reporte con imagen
2. Confirmar carga desde servidor
3. Probar zoom y visualización completa
4. Verificar funcionamiento en modo oscuro
```

### 🐛 Testing de Errores
- ❌ Conexión de red fallida
- ❌ Tokens expirados
- ❌ Formularios con datos inválidos
- ❌ Subida de archivos fallida

---

## 🧰 Requisitos del Sistema

### 📱 Dispositivo iOS
- **iOS 17.0** o superior
- **iPhone** (optimizado para todas las pantallas)
- **iPad** (compatible con interfaz adaptativa)

### 💻 Desarrollo
- **Xcode 15.0** o superior
- **Swift 5.9** o superior
- **macOS Sonoma** (recomendado)

### 🌐 Backend y Servicios
- **ngrok** instalado para túnel de desarrollo
- **Backend Node.js** corriendo localmente o en servidor
- **MySQL** configurado

---

## 🧑‍💻 Cómo Ejecutar la Aplicación

### 1. **Clonar el Repositorio**
```bash
git clone https://github.com/JavCan/FraudFishing.git
```

### 2. **Configurar el Backend**
```bash
# Asegúrate de que el backend esté corriendo
# Por ejemplo, en: https://xxxxx.ngrok-free.app
```

### 3. **Configurar la App**
```swift
// Editar: Fraud Fishing/Networking/HTTPClient.swift
let baseURL = "https://tu-ngrok-url.ngrok-free.app"
```

### 4. **Abrir en Xcode**
```bash
open "Fraud Fishing.xcodeproj"
```

### 5. **Ejecutar la Aplicación**
- Seleccionar simulador o dispositivo físico
- Presionar **⌘ + R** para compilar y ejecutar
- Para dispositivo físico: habilitar **Modo Desarrollador** en iOS

### 6. **Configuración Adicional (Opcional)**
```bash
# Para testing en dispositivo físico
# 1. Conectar iPhone via USB
# 2. Confiar en el certificado de desarrollador
# 3. Habilitar "Modo Desarrollador" en Ajustes > Privacidad y Seguridad
```

---

## 🔧 Configuración de Desarrollo

### 🌐 Variables de Entorno
```swift
// HTTPClient.swift - Configurar URL del backend
let baseURL = "https://your-backend-url.ngrok-free.app"
```

### 📱 Permisos de iOS
La app solicita los siguientes permisos:
- 📷 **Cámara y Fotos**: Para subir evidencias
- 🔔 **Notificaciones**: Para alertas de seguridad
- 🌐 **Red**: Para comunicación con API

---

## 🚀 Roadmap y Futuras Posibles Funcionalidades

### 🔮 Próximas Versiones
- [ ] 🤖 **IA para detección automática** de sitios fraudulentos
- [ ] 🌍 **Mapa interactivo** de reportes por ubicación
- [ ] 👥 **Sistema de reputación** de usuarios
- [ ] 📊 **Analytics avanzados** con Machine Learning
- [ ] 🔔 **Notificaciones push** en tiempo real
- [ ] 🌐 **Versión web** complementaria
- [ ] 📱 **Widget de iOS** para acceso rápido

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. 🍴 Fork el proyecto
2. 🌿 Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push a la rama (`git push origin feature/AmazingFeature`)
5. 🔄 Abre un Pull Request

---

<div align="center">
  <p><strong>🎣 Fraud Fishing - Protegiendo la comunidad digital, un reporte a la vez</strong></p>
  <p>Hecho con ❤️ y Swift en 🇲🇽</p>
</div>
