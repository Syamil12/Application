import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hello,'),
                  Image.asset('assets/images/Frame.png'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AspectRatio(
              aspectRatio: 327 / 199,
              child: Container(
                height: 327,
                margin: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFF4894FE),
                ),
              ),
            ),
          ],
        ),
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