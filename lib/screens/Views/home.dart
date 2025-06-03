import 'package:application/screens/Views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ScheduleScreen(),
    TaskScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: 
      Container(
        height: 80,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index){
            IconData icon;
            String label = '';
      
            switch (index) {
              case 0:
                icon = FeatherIcons.home;
                label = 'Home';
                break;
              case 1:
                icon = FeatherIcons.calendar;
                label = 'Schedule';
                break;
              case 2:
                icon = FeatherIcons.list;
                label = 'Result';
                break;
              default:
                icon = FeatherIcons.user;
                label = 'Profile';
            }
      
            final bool isSelected = _selectedIndex == index;
      
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: isSelected
                ? BoxDecoration(
                  color: const Color(0x1A63B4FF),
                  borderRadius: BorderRadius.circular(12),
                )
                : null,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected
                      ? const Color(0xFF4894FE)
                      : const Color(0xFF8688BB),
                  ),
                  if (isSelected && label.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF4894FE),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]
                ],
              ),  
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Schedule'),
    );
  }
}

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}