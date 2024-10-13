import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class SliverExample extends StatefulWidget {
  const SliverExample({super.key});

  @override
  State<SliverExample> createState() => _SliverExampleState();
}

class _SliverExampleState extends State<SliverExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
           SliverAppBar(

            expandedHeight: 400,
            pinned: true,
            backgroundColor: Color.fromRGBO(193, 136, 74, 1),
            toolbarHeight: 50,
            leading: Icon(Icons.arrow_back,color: Colors.white,),
            actions: [Icon(Icons.coffee_rounded,color: Colors.white,),SizedBox(width: 20,)],
            // floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('images/coffee.jpg',fit: BoxFit.cover,),
              title: Text("Coffee Cafe ☕",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
           ),
           SliverToBoxAdapter(
              child: MasonryGridView.count(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: 20,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(), 
                itemBuilder: (context,index){
                  double ht=((index%3)+1)*150;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InstaImageViewer(child: Image.asset('images/c${(index%8)+1}.jpg',fit: BoxFit.cover,height: ht,))),
                  );
                }),
            )
        ],
      ),
    );
  }
}

    
        