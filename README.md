# Artist-JG

SwiftUI iOS app architecture scaffold using MVVM + Coordinator + Combine.

## Structure

```text
Artist-JG
├── App
│   ├── AppCoordinator.swift
│   ├── AppRoute.swift
│   ├── ArtistJGApp.swift
│   └── RootView.swift
├── Core
│   ├── Constants
│   │   ├── AppConstants.swift
│   │   └── AppStrings.swift
│   ├── Networking
│   │   ├── APIClient.swift
│   │   ├── APIEndpoint.swift
│   │   ├── APIError.swift
│   │   └── APIMessageResponse.swift
│   └── Storage
│       └── AuthTokenStore.swift
├── Features
│   ├── Auth
│   │   ├── Models
│   │   ├── Services
│   │   ├── ViewModels
│   │   └── Views
│   └── Home
│       └── Views
└── Supporting
    └── Info.plist
```

## API

Base URL:

```text
http://139.84.173.186
```

Implemented endpoints:

- `POST /api/auth/registration-otp`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

The admin user endpoints are represented in `AuthEndpoint` and can be connected when their request/response bodies are available.

## Xcode Setup

Open `Artist-JG.xcodeproj` in Xcode, choose the `Artist-JG` scheme, then run it on an iPhone simulator or device.

The included `Supporting/Info.plist` keeps the required HTTP exception for the current API.
