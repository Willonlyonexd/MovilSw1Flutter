import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lottie/lottie.dart';
import '../models/comunicado_model.dart';
import '../services/api_service.dart';
import 'comunicado_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final ApiService _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  List<Comunicado> _comunicados = [];
  List<Comunicado> _comunicadosFiltrados = [];
  Map<DateTime, List<Comunicado>> _comunicadosPorFecha = {};

  @override
  void initState() {
    super.initState();
    _fetchComunicados();
  }

  void _fetchComunicados() async {
    try {
      final comunicados = await _apiService.getComunicados();
      setState(() {
        _comunicados = comunicados;
        _comunicadosPorFecha = _agruparComunicadosPorFecha(comunicados);
        _filtrarComunicadosPorFecha(_selectedDate);
      });
    } catch (e) {
      print("Error al obtener los comunicados: $e");
    }
  }

  Map<DateTime, List<Comunicado>> _agruparComunicadosPorFecha(List<Comunicado> comunicados) {
    Map<DateTime, List<Comunicado>> comunicadosMap = {};
    for (var comunicado in comunicados) {
      DateTime fecha = DateTime.parse(comunicado.fecha).toLocal();
      fecha = DateTime(fecha.year, fecha.month, fecha.day); // Solo la fecha, sin la hora
      if (comunicadosMap[fecha] == null) {
        comunicadosMap[fecha] = [];
      }
      comunicadosMap[fecha]!.add(comunicado);
    }
    return comunicadosMap;
  }

  void _filtrarComunicadosPorFecha(DateTime date) {
    setState(() {
      DateTime fechaFiltrar = DateTime(date.year, date.month, date.day);
      _comunicadosFiltrados = _comunicadosPorFecha[fechaFiltrar] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 23, 43, 1),
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _filtrarComunicadosPorFecha(selectedDay);
                });
              },
              eventLoader: (day) {
                DateTime dayKey = DateTime(day.year, day.month, day.day);
                return _comunicadosPorFecha[dayKey] ?? [];
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.white70),
                defaultTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_comunicadosFiltrados.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - nocomunicados.json',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No hay comunicados para esta fecha',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1731520533376sicomunicados.json',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Comunicados para esta fecha',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            child: _comunicadosFiltrados.isEmpty
                ? Container() // Espacio para animación y texto cuando no hay comunicados
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _comunicadosFiltrados.length,
                    itemBuilder: (context, index) {
                      final comunicado = _comunicadosFiltrados[index];
                      return Card(
                        color: const Color.fromRGBO(33, 34, 56, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            comunicado.nombre,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            comunicado.descripcion,
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 145, 0)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComunicadoDetailScreen(comunicado: comunicado),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
