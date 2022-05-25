import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget{
  const SearchScreen({Key? key}) : super(key:key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Buscar usuario'
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUser = true;
            });
            //print(_);
          },
        ),
      ),
      body: isShowUser ? FutureBuilder(
      //body: FutureBuilder(
        future: FirebaseFirestore.instance
          .collection('users')
          .where('username',isGreaterThanOrEqualTo: searchController.text).get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: (snapshot.data! as dynamic).docs[index]['uid']
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      (snapshot.data! as dynamic).docs[index]['photoUrl']
                    ),
                    radius: 16,
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username']
                  ),
                ),
              );
            },
          );
        },
      ) : Text('')
        
      //  : FutureBuilder(
      //     future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }

      //       return GridView.builder(
      //         shrinkWrap: true,
      //         itemCount: (snapshot.data! as dynamic).docs.length,
      //           gridDelegate:
      //             const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 3,
      //               crossAxisSpacing: 5,
      //               mainAxisSpacing: 1.5,
      //               childAspectRatio: 1,
      //             ),
      //           itemBuilder: (context, index) {
      //             DocumentSnapshot snap =(snapshot.data! as dynamic).docs[index];
      //               return Container(
      //                 child: Image(
      //                   image: NetworkImage(snap['postUrl']),
      //                   fit: BoxFit.cover,
      //                 ),
      //               );
      //           },
      //         );
      //       },
      //     )
      
    );
  }
}