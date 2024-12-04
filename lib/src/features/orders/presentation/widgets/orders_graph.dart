import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class OrdersGraph extends StatefulWidget {
  final List<FlSpot> spots;
  final Color primaryColor;

  const OrdersGraph({
    super.key,
    required this.spots,
    required this.primaryColor,
  });

  @override
  State<OrdersGraph> createState() => _OrdersGraphState();
}

class _OrdersGraphState extends State<OrdersGraph> {
  static const double _visibleDays = 7.0;
  late double _minX;
  late double _maxX;
  late double _viewportSize;
  late double _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeViewport();
  }

  @override
  void didUpdateWidget(OrdersGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spots != oldWidget.spots) {
      _initializeViewport();
    }
  }

  void _initializeViewport() {
    if (widget.spots.isEmpty) return;
    
    _minX = widget.spots.first.x;
    _maxX = widget.spots.last.x;
    _viewportSize = 86400000.0 * _visibleDays; // 7 days in milliseconds
    _currentPosition = _maxX - _viewportSize; // Start at the end
  }

  List<FlSpot> _getVisibleSpots() {
    if (widget.spots.isEmpty) return [];
    
    final visibleStart = _currentPosition;
    final visibleEnd = _currentPosition + _viewportSize;
    
    return widget.spots.where((spot) =>
      spot.x >= visibleStart && spot.x <= visibleEnd
    ).toList();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      final newPosition = _currentPosition - details.primaryDelta! * 86400000.0 / 100;
      _currentPosition = newPosition.clamp(_minX, _maxX - _viewportSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.spots.isEmpty) {
      return const Center(
        child: Text(
          'No data available for graph',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final visibleSpots = _getVisibleSpots();
    final maxY = widget.spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 1;

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      child: LineChart(
        LineChartData(
          minX: _currentPosition,
          maxX: _currentPosition + _viewportSize,
          minY: 0,
          maxY: maxY,
          clipData: FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 86400000, // 1 day in milliseconds
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 86400000, // 1 day in milliseconds
                getTitlesWidget: (value, meta) {
                  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: widget.spots, // Use all spots for smooth scrolling
              isCurved: false, // Disable curve for better performance
              color: widget.primaryColor,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: widget.primaryColor,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: widget.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
                  return LineTooltipItem(
                    '${DateFormat('MM/dd/yyyy').format(date)}\n${touchedSpot.y.toInt()} orders',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
