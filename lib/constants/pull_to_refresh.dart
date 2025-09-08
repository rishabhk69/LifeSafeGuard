import 'package:flutter/material.dart';

class PullRefresh extends StatefulWidget {
  Future<void> Function()? onRefresh;
  Widget? child;

  PullRefresh({this.onRefresh, this.child});


  @override
  State<PullRefresh> createState() => _PullRefreshState();
}

class _PullRefreshState extends State<PullRefresh> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh!,
      child: widget.child!,
    );
  }
}
