import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/data/model/images_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final imagesCubit = BlocProvider.of<ImagesCubit>(context);
    imagesCubit.getImages(MediaQuery.of(context).size, 500);
    return Scaffold(
      appBar: AppBar(
        title: Text('FindYourLéo'),
        centerTitle: true,
      ),
      body: BlocConsumer<ImagesCubit, ImagesState>(
        builder: (context, state) {
          if (state is ImagesLoaded) {
            return buildGridView(state.images);
          } else {
            return buildLoading();
          }
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildGridView(ImagesModel images) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 15,
      child: AbsorbPointer(
        child: Container(
          color: Colors.grey[900],
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(2.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: images.axisCount,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            children: images.images,
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
