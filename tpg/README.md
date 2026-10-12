# SmartMart Retail Inventory Management App

**TPG226C Technical Programming IIA — Group Project**

## Project overview

SmartMart is a Flutter application for managing a small retail product inventory. It allows users to view product information, add products, edit existing products, and delete products after confirmation. Product data is stored locally in a plain-text `products.txt` file.

## Group members

| Student number | Full name |
|---|---|
| 222078921 | Rethabile Mosoeu |
| 225094388 | Zenande Silinga |
| 224008297 | Ubabalwe Ndima |
| 225024254 | Phiwe Bunu |
| 223086483 | Buko Manqana |

## Main features

- Product list displayed with `ListView.builder` and local category images.
- Product details screen.
- Add and edit product forms.
- Form validation for required product code and name, price greater than zero, and quantity of zero or more.
- Stock status display, including available, low-stock, and out-of-stock products.
- Confirmation before deleting a product.
- Local inventory persistence using Dart `dart:io` and `path_provider`.

## Platform compatibility

The primary demonstration platform for this project is **Windows desktop**. The project includes Windows and Android platform files. Android requires a configured Android SDK and a compatible device or emulator; other platform folders are Flutter project scaffolding and have not been verified as supported targets.

The current implementation is **not compatible with Flutter Web**. Browser targets such as Chrome and Microsoft Edge do not support the native `dart:io` file operations used to read and write the inventory file.

## Running on Windows

Install Flutter and the Windows desktop build prerequisites, then open a terminal in the project folder (the folder containing `pubspec.yaml`) and run:

```powershell
flutter pub get
flutter run -d windows
```

To run a previously built Windows release, launch:

```powershell
.\build\windows\x64\runner\Release\smartmart_inventory.exe
```

The release executable is generated when the Windows target is built; it is not included in this source archive.

## Running on Android

Connect an Android device with USB debugging enabled or start an Android emulator. From the project folder, run:

```bash
flutter pub get
flutter devices
flutter run -d <device-id>
```

Replace `<device-id>` with the identifier shown by `flutter devices`. Android compatibility should be confirmed by building and testing on the intended device.

## Inventory data and persistence

On first launch, SmartMart creates `products.txt` in the application's local documents directory and initializes it with five sample products. On later launches, it reads the existing file. Adding, editing, or deleting products updates the file so the changes remain after restarting the application.

The information icon on the Product List screen displays the location of the active inventory file. The root-level `products.txt` included in this project is the sample data file for inspection; the active file is stored in the application's local documents directory.

Each record contains six comma-separated fields in this order:

```text
ProductCode,ProductName,Category,Price,Quantity,Status
```

The included sample data is:

```text
PRD001,Coca-Cola 2L,Beverages,24.99,35,Available
PRD002,White Bread,Bakery,18.50,12,Available
PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock
PRD004,Washing Powder 2kg,Household,79.99,0,Out of Stock
PRD005,USB Keyboard,Electronics,199.99,8,Available
```

Product category images are bundled in `assets/images/` and declared in `pubspec.yaml`.
# smartapp
