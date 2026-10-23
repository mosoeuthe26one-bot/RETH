import 'dart:io';

void main() {
  stdout.writeln('Enter your name:');
  String user = stdin.readLineSync()!;
  createUser(name: 'Ayanda'); // Ayanda, 18, unknown
  createUser(city: 'Durban', name: user, age: 25); // order free
  announce();
  stdout.writeln('enter value a');
  double a = double.parse(stdin.readLineSync()!);
  stdout.writeln('enter value b');
  double b = double.parse(stdin.readLineSync()!);
  double area = calculateRecArea(a, b);
  stdout.writeln('The area of the rectangle is: $area');
}

double calculateRecArea([double L=2, double w=2]) => L * w;

void announce([String? name='User']) {
  stdout.writeln('Hello $name \nWelcome to the rectangle area calculator!');
}


void createUser({required String name, int age = 18, String? city}) {
print('$name, $age, ${city ?? "unknown"}');
}
