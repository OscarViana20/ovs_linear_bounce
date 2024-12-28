import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bar.dart';
import '../widgets/painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double x = 0; // Inicializar en el centro
  double y = 0; // Ajuste de posición en el eje Y
  double dx = 4.0; // Movimiento horizontal
  double dy = -4.0; // Movimiento vertical
  bool _started = false; // Controla si la animación ha comenzado
  double ballRadius = 10.0; // Radio de la bola

  final List<Bar> bars = [];
  final FocusNode _focusNode = FocusNode();

  late Timer _timer; // Temporizador para la animación

  void _startAnimation(double width, double height) {
    if (!_started) {
      setState(() => _started = true);
      _timer = Timer.periodic(
        const Duration(milliseconds: 10),
        (timer) {
          setState(
            () {
              // Actualizar la posición del circulo
              x += dx;
              y += dy;

              // Verificar rebotes en los bordes del canvas
              if (x + dx > width - ballRadius || x + dx < ballRadius) {
                dx = -dx; // Rebotar en el borde horizontal
              }

              if (y + dy > height - kToolbarHeight - 3 * ballRadius ||
                  y + dy < ballRadius) {
                dy = -dy; // Rebotar en el borde vertical
              }

              for (var bar in bars) {
                // verificar rebotes en el pad horizontal
                if (x + dx > bar.x - ballRadius &&
                    x + dx < bar.x + bar.width &&
                    y + dy > bar.y - ballRadius &&
                    y + dy < bar.y + bar.height) {
                  dy = -dy;
                }
              }
            },
          );
        },
      );
    }
  }

  void initialize() {
    x = widget.size.width / 2 - ballRadius / 2;
    y = widget.size.height / 2 - ballRadius / 2;
    bars.add(Bar(
      x: (widget.size.width - 200) / 2,
      y: widget.size.height / 1.5,
      width: 200.0,
      height: 10.0,
    ));
    bars.add(Bar(
      x: (widget.size.width - 250) / 2,
      y: widget.size.height / 5,
      width: 250.0,
      height: 10.0,
    ));
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Linear Bouncer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.space) {
              _startAnimation(
                widget.size.width,
                widget.size.height,
              );
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onTap: () => _startAnimation(
              widget.size.width,
              widget.size.height,
            ),
            child: Container(
              width: widget.size.width,
              height: widget.size.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CustomPaint(
                painter: BallPainter(x, y, ballRadius, bars),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
