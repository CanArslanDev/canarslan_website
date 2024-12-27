part of '../home_page.dart';

class InfiniteScrollImage extends StatefulWidget {
  const InfiniteScrollImage({super.key});

  @override
  InfiniteScrollImageState createState() => InfiniteScrollImageState();
}

class InfiniteScrollImageState extends State<InfiniteScrollImage> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Timer ile sürekli kaydırma işlemi
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.offset + 1, // Kaydırma hızı
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: 200, // Görselin yüksekliği
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                3,
                0,
                0,
                0,
                -1,
                0,
                3,
                0,
                0,
                -1,
                0,
                0,
                3,
                0,
                -1,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: Image.asset(
                'assets/images/wallpaper.png',
                fit: BoxFit.cover,
                width: 100.w,
              ),
            );
          },
        ),
      ),
    );
  }
}
