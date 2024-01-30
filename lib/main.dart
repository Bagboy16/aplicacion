import 'package:flutter/material.dart';

/*
  Función principal de la aplicación
  llama a la función runApp() que recibe como parámetro
  un widget de tipo MaterialApp
  
  ¿Qué es un widget?
  Es una clase que permite crear un elemento de la interfaz de usuario
  en este caso MaterialApp es un widget que permite crear una aplicación
  con un tema personalizado

  Los widgets son inmutables, es decir, no pueden cambiar sus propiedades
  una vez que se han creado, por lo que si se desea cambiar alguna propiedad
  se debe crear un nuevo widget con las propiedades deseadas

  Estados de la aplicación
  Los widgets pueden tener dos estados:
  1. Estado estático: no cambia con el tiempo
  2. Estado dinámico: puede cambiar durante la interacción con el usuario
  Estado efímero: es un estado que se puede cambiar durante la interacción con el usuario (estado dinámico)
  Estado persistente: es un estado que no cambia durante la interacción con el usuario (estado estático) 
  Los widgets de estado efímero se denominan widgets interactivos y los widgets de estado persistente se denominan widgets pasivos

  Clases de widgets
  Stateless widgets: son widgets que no tienen estado, es decir, no cambian durante la interacción con el usuario
  Stateful widgets: son widgets que tienen estado, es decir, pueden cambiar durante la interacción con el usuario
  Inherited widgets: son widgets que heredan propiedades a sus hijos, es decir, los hijos pueden acceder a las propiedades de los padres

 */

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      _displayText += buttonText;
    });
  }

  void _onClearPressed() {
    setState(() {
      _displayText = '';
    });
  }

  void _onCalculatePressed() {
    setState(() {
      //r al inicio de la cadena indica que es una cadena raw en Dart, lo que significa que los caracteres de escape no se procesan. Esto es útil cuando se trabaja con expresiones regulares, ya que a menudo contienen muchos caracteres de escape.

      // \d+\.?\d* es la primera parte de la expresión regular, que se encuentra entre paréntesis. Esta parte se divide en tres segmentos:

      // \d+ busca uno o más dígitos (0-9).

      // \.? busca cero o un punto decimal. El carácter de escape \ es necesario porque un punto sin escapar significa "cualquier carácter" en una expresión regular.

      // \d* busca cero o más dígitos. Esto permite números decimales después del punto.

      // [+-/*] es la segunda parte de la expresión regular, que también se encuentra entre paréntesis. Esta parte busca cualquiera de los operadores de suma, resta, multiplicación o división.

      // | es el operador OR en las expresiones regulares. Significa que la expresión regular buscará coincidencias que se ajusten a la primera parte (números) o a la segunda parte (operadores).

      RegExp regExp = RegExp(r'(\d+\.?\d*)|([+-/*])');

      List<String?> tokens =
          regExp.allMatches(_displayText).map((e) => e.group(0)).toList();

      double result = double.parse(tokens[0]!);

      for (int i = 1; i < tokens.length - 1; i++) {
        String? token = tokens[i];
        switch (token) {
          case '+':
            result =
                double.parse(tokens[i - 1]!) + double.parse(tokens[i + 1]!);
            tokens[i - 1] = result.toString();
            tokens.removeAt(i);
            tokens.removeAt(i);
            i--;
            break;
          case '-':
            result =
                double.parse(tokens[i - 1]!) - double.parse(tokens[i + 1]!);
            tokens[i - 1] = result.toString();
            tokens.removeAt(i);
            tokens.removeAt(i);
            i--;
            break;
          case '*':
            result =
                double.parse(tokens[i - 1]!) * double.parse(tokens[i + 1]!);
            tokens[i - 1] = result.toString();
            tokens.removeAt(i);
            tokens.removeAt(i);
            i--;
            break;
          case '/':
            result =
                double.parse(tokens[i - 1]!) / double.parse(tokens[i + 1]!);
            tokens[i - 1] = result.toString();
            tokens.removeAt(i);
            tokens.removeAt(i);
            i--;
            break;
        }
      }
      _displayText = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _displayText,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _onClearPressed,
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onCalculatePressed,
                  child: const Text('Calculate'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(buttonText),
      ),
    );
  }
}
