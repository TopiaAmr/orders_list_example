import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// An interactive time-series graph widget for displaying order data.
/// 
/// Features:
/// - Status filtering through a dropdown
/// - Horizontal scrolling for date navigation
/// - Interactive tooltips showing order counts
/// - Gradient-filled area under the line
/// 
/// The graph automatically adjusts its viewport and scales based on the
/// provided data points.
class OrdersGraph extends StatefulWidget {
  /// Data points to display on the graph
  final List<FlSpot> spots;
  
  /// Primary color used for the line and gradient
  final Color primaryColor;
  
  /// List of all available order statuses for filtering
  final List<String> availableStatuses;
  
  /// Callback when user changes the status filter
  final Function(String?) onStatusChanged;
  
  /// Currently selected status
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

/// State for the OrdersGraph widget handling viewport calculations
/// and user interactions.
class _OrdersGraphState extends State<OrdersGraph> {
  /// Number of days visible in the viewport at once
  static const double _visibleDays = 7.0;
  
  /// Minimum x-coordinate (timestamp) in the data
  late double _minX;
  
  /// Maximum x-coordinate (timestamp) in the data
  late double _maxX;
  
  /// Size of the viewport in milliseconds
  late double _viewportSize;
  
  /// Current position of the viewport (left edge)
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

  /// Initializes the viewport parameters based on the data points.
  /// 
  /// Sets up:
  /// - Viewport size (7 days worth of milliseconds)
  /// - Min/max x coordinates
  /// - Initial viewport position
  void _initializeViewport() {
    if (widget.spots.isEmpty) return;
    
    _minX = widget.spots.first.x;
    _maxX = widget.spots.last.x;
    _viewportSize = 86400000.0 * _visibleDays; // 7 days in milliseconds
    _currentPosition = _maxX - _viewportSize; // Start at the end
  }

  /// Handles horizontal drag gestures to scroll the graph.
  /// 
  /// Updates the viewport position based on the drag delta,
  /// ensuring it stays within the valid range.
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

  /// Builds the status filter dropdown widget.
  /// 
  /// Shows a dropdown with all available statuses and an "All Statuses"
  /// option. The dropdown is styled with a border and proper spacing.
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
