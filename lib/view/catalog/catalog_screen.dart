import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalog/models/list/item_list.dart';

import '../../blocs/catalog_bloc.dart';
import '../../models/catalog/catalog_model.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

enum ActionPerformed {
  scroll,
  reload,
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CatalogBloc()..add(GetCatalogEvent()),
        child: const CatalogView());
  }
}

class CatalogView extends StatefulWidget {
  const CatalogView({Key? key}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final _scrollController = ScrollController();
  ActionPerformed currentAction = ActionPerformed.reload;
  late Completer<void> _refreshCompleter;
  ItemList? _itemList;
  bool _isLoading = false;
  bool _canBringMoreData = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state is ErrorState) {
          setState(() {
            _isLoading = false;
            stateCompleted();
          });
        }
        if (state is ArticlesLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is ArticlesReceivedState) {
          setState(() {
            _isLoading = false;
            evaluateListItem(state.items);
            stateCompleted();
          });
        }

        if (state is NoArticlesState) {
          setState(() {
            _isLoading = false;
            stateCompleted();
          });
        }
      },
      child: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text("Catalog"),
            ),
            body: RefreshIndicator(
                onRefresh: () {
                  //recall api
                  setState(() {
                    currentAction = ActionPerformed.reload;
                  });
                  BlocProvider.of<CatalogBloc>(context).add(GetCatalogEvent());
                  return _refreshCompleter.future;
                },
                child: Container(
                  color: Colors.white,
                  height: double.infinity,
                  child: Column(
                    children: [
                      isReloading(),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 0),
                          child: getMainContent(),
                        ),
                      ),
                      //loading indicator
                      isScrolling(),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  void stateCompleted() {
    _refreshCompleter.complete();
    _refreshCompleter = Completer();
  }

//*********************************
  Widget isReloading() {
    if (_isLoading && currentAction == ActionPerformed.reload)
      return loadingIndicator();
    return const SizedBox.shrink();
  }

  Widget isScrolling() {
    if (_isLoading && currentAction == ActionPerformed.scroll)
      return loadingIndicator();
    return const SizedBox.shrink();
  }

  //*****************************
  Widget loadingIndicator() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: const Center(child: CircularProgressIndicator()));
  }

//******************************
  Widget getMainContent() {
    if (_isLoading && currentAction == ActionPerformed.reload) return SizedBox.shrink();
    if (_itemList == null) return noArticlesView(context);
    return catalogList(catalog: _itemList!);
  }

//***********************
  Widget catalogList({required ItemList catalog}) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return catalogListItem(item: catalog.items[index]);
      },
      controller: _scrollController,
      itemCount: catalog.items.length - 1,
    );
  }

  //***********************
  ///Check if user is on the bottom
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  //***********************
  void _onScroll() {
    if (_isBottom && _canBringMoreData) {
      setState(() {
        //restricts the client to make multiple calls to the api
        _canBringMoreData = false;
        currentAction = ActionPerformed.scroll;
        context.read<CatalogBloc>().add(GetCatalogEvent());
      });
    }
  }

  void evaluateListItem(ItemList newItems) {
    _itemList ??= newItems;
    switch (currentAction) {
      case ActionPerformed.reload:
        _itemList = newItems;
        break;
      case ActionPerformed.scroll:
        //lets the client to bring more data from api
        setState(() {
          _canBringMoreData = true;
        });
        _itemList!.items.addAll(newItems.items);
        break;
    }
  }
}

//***********************
Widget catalogListItem({required CatalogModel item}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: InkWell(
      onTap: () {},
      child: Card(
        color: Color(0xfff1f1f1),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                imageUrl: item.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (item.articleName == null)
                      ? Text("")
                      : (item.articleName!.length > 25)
                          ? Text('${item.articleName!.substring(0, 20)}...')
                          : Text('${item.articleName!}'),
                  SizedBox(height: 0),
                  Text(item.mainDescriptions),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${item.localCost}.00",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        (item.isActive)
                            ? Text(
                                'Activo',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                'Inactivo',
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ),
  );
}

//***********************
Widget noArticlesView(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Aún no tienes artículos agregados.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    ),
  );
}
