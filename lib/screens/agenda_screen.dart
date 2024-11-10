import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Eventos categorizados por tipo
  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2024, 10, 22): [
      {'tipo': 'Tarea', 'titulo': 'Matemáticas: Ecuaciones'},
      {'tipo': 'Comunicado', 'titulo': 'Reunión de padres'},
    ],
    DateTime(2024, 10, 23): [
      {'tipo': 'Citaciones', 'titulo': 'Entrevista con dirección'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(21, 23, 43, 1),
      body: Column(
        children: [
          // Calendario en la parte superior
          SizedBox(height: 30), // Espacio vertical de 20 píxeles
          SizedBox(width: 10),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2025),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.red),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(color: Colors.white),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 10),
          // Lista de eventos del día seleccionado
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  // Widget para construir la lista de eventos del día seleccionado
  Widget _buildEventList() {
    final events = _events[_selectedDay] ?? [];

    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No hay eventos para este día.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          leading: _getIconForEvent(event['tipo']!),
          title: Text(
            event['titulo']!,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            event['tipo']!,
            style: const TextStyle(color: Colors.white54),
          ),
        );
      },
    );
  }

  // Método para obtener un ícono basado en el tipo de evento
  Widget _getIconForEvent(String tipo) {
    switch (tipo) {
      case 'Tarea':
        return const Icon(Icons.assignment, color: Colors.blue);
      case 'Comunicado':
        return const Icon(Icons.campaign, color: Colors.orange);
      case 'Citaciones':
        return const Icon(Icons.people, color: Colors.red);
      default:
        return const Icon(Icons.event, color: Colors.white);
    }
  }
}
