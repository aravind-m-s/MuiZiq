// closed due to API server Issue

// // ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:muiziq_app/constants/constants.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class ScreenFindSong extends StatefulWidget {
//   const ScreenFindSong({super.key});

//   @override
//   State<ScreenFindSong> createState() => _ScreenFindSongState();
// }

// class _ScreenFindSongState extends State<ScreenFindSong> {
//   startListening() async {
//     await arc.start();
//   }

//   stop() async {
//     await arc.stop();
//   }

//   bool _isAnimate = false;
//   String _text = "Press the mic Icon to start listening";

//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance.addPostFrameCallback(
//     //   (_) => BlocProvider.of<FindSongBloc>(context).add(Initialize()),
//     // );
//     return Scaffold(
//       body: SafeArea(
//         child: ValueListenableBuilder(
//           valueListenable: list,
//           builder: (context, value, child) {
//             if (value == null) {
//               stop();
//               _isAnimate = false;
//               _text = "Press the mic Icon to start listening";

//               return noMatchFound();
//             } else if (value.isEmpty) {
//               return listeningWidget();
//             } else {
//               stop();
//               _isAnimate = false;
//               _text = "Press the mic Icon to start listening";

//               return foundSong(value);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Center foundSong(value) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           listenAnotherSong(),
//           kHeight30,
//           ValueListenableBuilder(
//             valueListenable: img,
//             builder: (context, value, child) {
//               if (img.value != '') {
//                 return imageFromAudio();
//               }
//               return musicImage();
//             },
//           ),
//           kHeight20,
//           musicDetails(value),
//           kHeight30,
//           searchButtons(value),
//           kHeight30,
//         ],
//       ),
//     );
//   }

//   Container imageFromAudio() {
//     return Container(
//       height: 200,
//       width: 200,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: NetworkImage(img.value), fit: BoxFit.contain),
//       ),
//     );
//   }

//   Row searchButtons(value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         youtubeSeach(value),
//         kWidth30,
//         spotifySearch(value),
//       ],
//     );
//   }

//   SizedBox spotifySearch(value) {
//     return SizedBox(
//       height: 50,
//       child: ElevatedButton.icon(
//         icon: const Icon(Icons.search),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//         ),
//         onPressed: () {
//           String title = value[0].title.trim();
//           String artist = value[0].artists.last.name.trim();
//           if (title.contains(" ")) {
//             title = title.replaceAll(" ", '%20');
//           }
//           if (artist.contains(" ")) {
//             artist = artist.replaceAll(" ", '%20');
//           }

//           final String query =
//               'https://open.spotify.com/search/results/$title%20by%20$artist';
//           launchUrlString(query);
//         },
//         label: const Text("Spotify"),
//       ),
//     );
//   }

//   SizedBox youtubeSeach(value) {
//     return SizedBox(
//       height: 50,
//       child: ElevatedButton.icon(
//         icon: const Icon(Icons.search),
//         style: ElevatedButton.styleFrom(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           backgroundColor: Colors.red,
//         ),
//         onPressed: () {
//           String title = value[0].title.trim();
//           String artist = value[0].artists.last.name.trim();
//           if (title.contains(" ")) {
//             title = title.replaceAll(" ", '+');
//           }
//           if (artist.contains(" ")) {
//             artist = artist.replaceAll(" ", '+');
//           }

//           final String query =
//               'https://m.youtube.com/results?sp=mAEA&search_query=$title+by+$artist';
//           launchUrlString(query);
//         },
//         label: const Text("Youtube"),
//       ),
//     );
//   }

//   Column musicDetails(value) {
//     return Column(
//       children: [
//         Text(
//           value[0].title,
//           style: const TextStyle(color: textColor, fontSize: 23),
//         ),
//         kHeight10,
//         Text(
//           value[0].artists.last.name,
//           style: const TextStyle(color: authColor, fontSize: 15),
//         ),
//       ],
//     );
//   }

//   Container musicImage() {
//     return Container(
//       height: 200,
//       width: 200,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage('lib/assets/MuiZiq.png'), fit: BoxFit.contain),
//       ),
//     );
//   }

//   SizedBox listenAnotherSong() {
//     return SizedBox(
//       height: 50,
//       child: ElevatedButton.icon(
//         icon: const Icon(Icons.mic),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: themeColor,
//         ),
//         onPressed: () {
//           list.value = [];
//           list.notifyListeners();
//         },
//         label: const Text("Identify another song"),
//       ),
//     );
//   }

//   Center listeningWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _text,
//             style: const TextStyle(color: textColor, fontSize: 20),
//           ),
//           InkWell(
//             onTap: () {
//               _text = "Listening...";
//               _isAnimate = true;
//               setState(() {
//                 startListening();
//               });
//             },
//             child: AvatarGlow(
//               endRadius: 200,
//               animate: _isAnimate,
//               child: const CircleAvatar(
//                 radius: 80,
//                 child: Icon(
//                   Icons.mic,
//                   size: 50,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Center noMatchFound() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Oops! No match found',
//             style: TextStyle(color: textColor, fontSize: 20),
//           ),
//           kHeight20,
//           SizedBox(
//             height: 50,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: themeColor,
//               ),
//               onPressed: () {
//                 list.value = [];
//                 list.notifyListeners();
//               },
//               child: const Text("Identify another song"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
