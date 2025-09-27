import 'package:flutter/material.dart';
import '../services/performance_service.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  Map<String, dynamic>? _performanceData;

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  void _loadPerformanceData() {
    setState(() {
      _performanceData = PerformanceService.instance.getPerformanceData();
    });
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _performanceData == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No performance data available yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete some quizzes to see your performance metrics!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Performance Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Track your progress and improvement over time',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Performance metrics grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildPerformanceCard(
                          'Total Quizzes\nCompleted',
                          '${_performanceData?['total_quizzes'] ?? 0}',
                          Icons.quiz,
                          Colors.blue,
                        ),
                        _buildPerformanceCard(
                          'Average\nAccuracy',
                          '${_performanceData?['average_accuracy'] ?? 0}%',
                          Icons.target,
                          Colors.green,
                        ),
                        _buildPerformanceCard(
                          'Total Questions\nAnswered',
                          '${_performanceData?['total_questions'] ?? 0}',
                          Icons.question_answer,
                          Colors.orange,
                        ),
                        _buildPerformanceCard(
                          'Average Time\nper Question',
                          '${_performanceData?['avg_time_per_question'] ?? 0}s',
                          Icons.timer,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent activity
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_performanceData?['recent_events'] != null)
                      ...(_performanceData!['recent_events'] as List).map((event) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getEventColor(event['event_type']).withOpacity(0.2),
                            child: Icon(
                              _getEventIcon(event['event_type']),
                              color: _getEventColor(event['event_type']),
                            ),
                          ),
                          title: Text(_getEventTitle(event)),
                          subtitle: Text(_getEventSubtitle(event)),
                          trailing: Text(
                            _formatEventTime(event['timestamp']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ))
                    else
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No recent activity to display',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPerformanceData,
        tooltip: 'Refresh Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'quiz_start':
        return Colors.blue;
      case 'quiz_end':
        return Colors.green;
      case 'question_answered':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType) {
      case 'quiz_start':
        return Icons.play_arrow;
      case 'quiz_end':
        return Icons.check_circle;
      case 'question_answered':
        return Icons.question_answer;
      default:
        return Icons.event;
    }
  }

  String _getEventTitle(Map<String, dynamic> event) {
    switch (event['event_type']) {
      case 'quiz_start':
        return 'Started Quiz';
      case 'quiz_end':
        return 'Completed Quiz';
      case 'question_answered':
        return 'Answered Question';
      default:
        return 'Event';
    }
  }

  String _getEventSubtitle(Map<String, dynamic> event) {
    switch (event['event_type']) {
      case 'quiz_start':
        return 'Quiz: ${event['data']?['type'] ?? 'Unknown'}';
      case 'quiz_end':
        final data = event['data'] ?? {};
        return 'Score: ${data['score'] ?? 0}/${data['total_questions'] ?? 0} '
               '(${data['accuracy'] ?? 0}%)';
      case 'question_answered':
        final data = event['data'] ?? {};
        return data['correct'] == true
            ? 'Correct answer in ${data['time_to_answer_seconds'] ?? 0}s'
            : 'Incorrect answer in ${data['time_to_answer_seconds'] ?? 0}s';
      default:
        return 'No details available';
    }
  }

  String _formatEventTime(int? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}