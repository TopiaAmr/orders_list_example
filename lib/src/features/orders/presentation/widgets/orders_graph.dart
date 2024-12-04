import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class OrdersGraph extends StatefulWidget {
  final List<FlSpot> spots;
  final Color primaryColor;
  final List<String> availableStatuses;
  final Function(String?) onStatusChanged;
  final String? selectedStatus;

  const OrdersGraph({
    super.key,
    required this.spots,
    required this.primaryColor,
    required this.availableStatuses,
    required this.onStatusChanged,
    this.selectedStatus,
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

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      final newPosition = _currentPosition - details.primaryDelta! * 86400000.0 / 100;
      _currentPosition = newPosition.clamp(_minX, _maxX - _viewportSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.spots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusFilter(),
            const SizedBox(height: 16),
            const Text(
              'No data available for selected status',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final maxY = widget.spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 1;

    return Column(
      children: [
        _buildStatusFilter(),
        const SizedBox(height: 16),
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: LineChart(
              LineChartData(
                minX: _currentPosition,
                maxX: _currentPosition + _viewportSize,
                minY: 0,
                maxY: maxY,
                clipData: const FlClipData.all(),
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
                      reservedSize: 30,
                      interval: 86400000,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.spots,
                    isCurved: true,
                    color: widget.primaryColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: widget.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                          touchedSpot.x.toInt(),
                        );
                        return LineTooltipItem(
                          '${DateFormat('MM/dd/yyyy').format(date)}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: touchedSpot.y.toInt().toString(),
                              style: TextStyle(
                                color: widget.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ' orders',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Filter by Status:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: widget.selectedStatus,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Statuses'),
                ),
                ...widget.availableStatuses.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                )),
              ],
              onChanged: widget.onStatusChanged,
            ),
          ),
        ],
      ),
    );
  }
}
