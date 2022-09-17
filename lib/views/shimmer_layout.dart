import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLyoutPostList extends StatefulWidget {
  const ShimmerLyoutPostList({super.key});

  @override
  State<ShimmerLyoutPostList> createState() => _ShimmerLyoutPostListState();
}

class _ShimmerLyoutPostListState extends State<ShimmerLyoutPostList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 80.0,
                      width: 120.0,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SizedBox(
                          height: 10.0,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(1.0),
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SizedBox(
                          height: 10.0,
                          width: 100,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const LikeButton(),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.orange),
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                      child: const SizedBox(
                        width: 30,
                        height: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerLayoutCategoryList extends StatelessWidget {
  const ShimmerLayoutCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  height: 120.0,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.orange),
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                  child: const SizedBox(
                    width: 100,
                    height: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
