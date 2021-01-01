import 'package:find_your_leo/constants.dart';
import 'package:find_your_leo/cubit/home_cubit.dart';
import 'package:find_your_leo/cubit/images_cubit.dart';
import 'package:find_your_leo/cubit/room_cubit.dart';
import 'package:find_your_leo/data/room_repository.dart';
import 'package:find_your_leo/screens/create/create_screen.dart';
import 'package:find_your_leo/screens/game/game_screen.dart';
import 'package:find_your_leo/screens/home/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<HomeScreen> {
  var textController = TextEditingController();

  Future<List<String>> _getRoomPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getStringList("find_the_compromise_room") == null) {
      return [];
    }
    print(pref.getStringList("find_the_compromise_room"));
    return pref.getStringList("find_the_compromise_room");
  }

  Future<void> _saveToRoomPref(String code) async {
    if (code == null) return;
    final SharedPreferences pref = await SharedPreferences.getInstance();

    Set<String> allCodes =
        pref.getStringList("find_the_compromise_room")?.toSet() ?? {};

    allCodes = {code, ...allCodes};

    pref.setStringList("find_the_compromise_room", allCodes.toList());
  }

  void onTileTaped(String code) {
    submitSearchingRoom(context, code);
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return buildScaffold();
  }

  Scaffold buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Find The Compromise'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        futurePref: _getRoomPref(),
        onTap: onTileTaped,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return buildInitialScreen();
          } else if (state is HomeLoading) {
            return buildLoading();
          } else if (state is HomeLoaded) {
            return buildInitialScreen();
          } else {
            return buildInitialScreen();
          }
        },
        listener: (context, state) {
          if (state is HomeError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is HomeLoaded) {
            _saveToRoomPref(textController.text);
            _getRoomPref();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => ImagesCubit(RoomRepository()),
                    child: GameScreen(levels: state.levels),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInitialScreen() {
    return Center(
      child: Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: textController,
                  onSubmitted: (value) => submitSearchingRoom(context, value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Rechercher une partie",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              RaisedButton(
                onPressed: () {
                  onCreateGameButtonPressed();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey)),
                child:
                    Text('Créer ta partie !', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void onCreateGameButtonPressed() async {
    final String code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            create: (context) => RoomCubit(RoomRepository()),
            child: CreateScreen(),
          );
        },
      ),
    );

    if (code != null && code.isNotEmpty) {
      textController.text = code;
    }
  }

  void submitSearchingRoom(BuildContext context, String value) {
    final myCubit = BlocProvider.of<HomeCubit>(context);
    myCubit.getRoom(context, value);
  }
}
