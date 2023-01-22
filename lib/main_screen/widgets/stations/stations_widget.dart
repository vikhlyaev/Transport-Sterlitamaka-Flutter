import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class StationsWidget extends StatefulWidget {
  const StationsWidget({super.key});

  @override
  State<StationsWidget> createState() => _StationsWidgetState();
}

class _StationsWidgetState extends State<StationsWidget> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Остановки'),
      ),
      body: Stack(
        children: [
          ListView.separated(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 90),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage(Images.iconStation)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '23 мая',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'в сторону ул. Гоголя',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFD9D9D9),
              height: 1,
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Укажите название остановки',
                  labelText: 'Поиск',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
