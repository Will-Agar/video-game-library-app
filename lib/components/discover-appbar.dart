import 'package:flutter/material.dart';
import '../constants/color-constants.dart';
import '../models/search-parameters.dart';

class DiscoverAppbar extends StatefulWidget {
  DiscoverAppbar({Key key, this.setSearchParameters}) : super(key: key);

  final Function setSearchParameters;

  @override
  _DiscoverAppbarState createState() => _DiscoverAppbarState();
}

class _DiscoverAppbarState extends State<DiscoverAppbar> {
  static ColorConstants colorConstants = new ColorConstants();
  final searchController = TextEditingController();
  final _scrollController = ScrollController();
  SearchParameters searchParameters = new SearchParameters();

  bool searched = false;
  bool displayModal = false;
  bool sortFilterApplied = false;

  final OutlineInputBorder standardBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(color: colorConstants.primary, width: 2)
  );
  final TextStyle inputTextStyle = TextStyle(
      color: colorConstants.primary,
      fontWeight: FontWeight.w500,
      fontSize: 20
  );
  final TextStyle inputHintTextStyle = TextStyle(
    color: colorConstants.primary,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  showModal(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 600,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colorConstants.primary, width: 3)),
                color: colorConstants.secondary,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Scrollbar(
                  controller: _scrollController,
                  radius: Radius.circular(5),
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container()
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Filter and Sort',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: colorConstants.tertiary, fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.clear, color: colorConstants.tertiary, size: 30),
                                      onPressed: hideModal,
                                    )
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Genres",
                            style: TextStyle(color: colorConstants.primary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: getGenreChips(setModalState),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Container()),
                          Text(
                            "Platforms",
                            style: TextStyle(color: colorConstants.primary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: getPlatformChips(setModalState),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Container()),
                          Text(
                            "Multiplayer",
                            style: TextStyle(color: colorConstants.primary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () => selectMultiplayer(setModalState),
                              child: this.searchParameters.filterOptions.multiplayer?
                              Chip(
                                label: Text("Mutiplayer Enabled", style: TextStyle(color: colorConstants.secondary)),
                                backgroundColor: colorConstants.primary,
                              ):
                              Chip(
                                label: Text("Mutiplayer Enabled", style: TextStyle(color: colorConstants.primary)),
                                backgroundColor: colorConstants.secondary,
                                side: BorderSide(color: colorConstants.primary, width: 1),
                              )
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Container()),
                          Text(
                            "Sort By",
                            style: TextStyle(color: colorConstants.primary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: getSortChips(setModalState),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                height: 60,
                                minWidth: 100,
                                color: colorConstants.secondary,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colorConstants.tertiary, width: 2),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: apply,
                                child: Text(
                                  "Apply",
                                  style: TextStyle(color: colorConstants.primary, fontSize: 20),
                                ),
                              ),
                              MaterialButton(
                                height: 60,
                                minWidth: 100,
                                color: colorConstants.secondary,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colorConstants.tertiary, width: 2),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: clear,
                                child: Text(
                                  "Clear",
                                  style: TextStyle(color: colorConstants.primary, fontSize: 20),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            );
          }
        );
      }
    );
  }

  apply(){
    Navigator.pop(context);
    if(searchParameters.isEmpty()){
      setState(() {
        sortFilterApplied = false;
      });
    }

    else{
      setState(() {
        sortFilterApplied = true;
      });
    }

    this.widget.setSearchParameters(searchParameters);
  }

  clear(){
    Navigator.pop(context);
    if(!searchParameters.isEmpty()){
      setState(() {
        searchParameters.clear();
        sortFilterApplied = false;
      });

      this.widget.setSearchParameters(searchParameters);
    }
  }

  hideModal(){
    Navigator.pop(context);
  }

  search(){
    if(searchController.text == "" && searchParameters.searchTerm != ""){
      removeSearch();
    }

    else if(searchController.text != searchParameters.searchTerm){
      this.setState(() {
        searchParameters.searchTerm = searchController.text;
        searched = true;
      });

      this.widget.setSearchParameters(searchParameters);
    }
  }

  removeSearch(){
    this.setState(() {
      searchController.text = '';
      searchParameters.searchTerm = '';
      searched = false;
    });

    this.widget.setSearchParameters(searchParameters);
  }

  selectSort(sort, StateSetter setModalState){
    if(searchParameters.sortBy == sort){
      searchParameters.sortBy = "";
    }

    else{
      searchParameters.sortBy = sort;
    }

    setModalState(() {});
    this.setState(() {});
  }

  selectMultiplayer(StateSetter setModalState){
    searchParameters.filterOptions.multiplayer = !searchParameters.filterOptions.multiplayer ;
    setModalState(() {});
    this.setState(() {});
  }

  selectGenre(genre, StateSetter setModalState){
    if(searchParameters.filterOptions.genres.contains(genre)){
      searchParameters.filterOptions.genres.remove(genre);
    }

    else{
      if(searchParameters.filterOptions.genres.length == 3){
        searchParameters.filterOptions.genres.removeAt(0);
      }

      searchParameters.filterOptions.genres.add(genre);
    }

    setModalState(() {});
    this.setState(() {});
  }

  selectPlatform(platform, StateSetter setModalState){
    if(searchParameters.filterOptions.platform == platform){
      searchParameters.filterOptions.platform = "";
    }

    else{
      searchParameters.filterOptions.platform = platform;
    }

    setModalState(() {});
    this.setState(() {});
  }

  List<Widget> getGenreChips(setModalState){
    List<Widget> genreChips = [];
    var genres = [
      "Action",
      "Adventure",
      "Role-playing",
      "Simulation",
      "Puzzle",
      "Strategy",
      "Sports",
      "MMO",
      "Driving",
      "Horror",
      "Survival",
      "Open World"
    ];

    genres.forEach((genre) {
      genreChips.add(
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: InkWell(
            onTap: () => selectGenre(genre, setModalState),
            child: searchParameters.filterOptions.genres.contains(genre)?
            Chip(
              label: Text(genre, style: TextStyle(color: colorConstants.secondary)),
              backgroundColor: colorConstants.primary,
            ):
            Chip(
              label: Text(genre, style: TextStyle(color: colorConstants.primary)),
              backgroundColor: colorConstants.secondary,
              side: BorderSide(color: colorConstants.primary, width: 1),
            )
          ),
        )
      );
    });

    return genreChips;
  }

  List<Widget> getPlatformChips(setModalState){
    List<Widget> platformChips = [];
    var platforms = [
      "Xbox",
      "PC",
      "Playstation"
    ];

    platforms.forEach((platform) {
      platformChips.add(
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: InkWell(
                onTap: () => selectPlatform(platform, setModalState),
                child: searchParameters.filterOptions.platform == platform?
                Chip(
                  label: Text(platform, style: TextStyle(color: colorConstants.secondary)),
                  backgroundColor: colorConstants.primary,
                ):
                Chip(
                  label: Text(platform, style: TextStyle(color: colorConstants.primary)),
                  backgroundColor: colorConstants.secondary,
                  side: BorderSide(color: colorConstants.primary, width: 1),
                )
            ),
          )
      );
    });

    return platformChips;
  }

  List<Widget> getSortChips(setModalState){
    List<Widget> sortChips = [];
    var sorts = [
      "Oldest First",
      "Newest First",
      "Best Rated",
      "Most Popular"
    ];

    sorts.forEach((sort) {
      sortChips.add(
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: InkWell(
                onTap: () => selectSort(sort, setModalState),
                child: searchParameters.sortBy == sort?
                Chip(
                  label: Text(sort, style: TextStyle(color: colorConstants.secondary)),
                  backgroundColor: colorConstants.primary,
                ):
                Chip(
                  label: Text(sort, style: TextStyle(color: colorConstants.primary)),
                  backgroundColor: colorConstants.secondary,
                  side: BorderSide(color: colorConstants.primary, width: 1),
                )
            ),
          )
      );
    });

    return sortChips;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.sort, color: sortFilterApplied? colorConstants.primary: colorConstants.tertiary, size: 30),
          onPressed: showModal,
        ),
        Container(
          height: 40,
          width: searched? 175: 225,
          child: Center(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              cursorColor: colorConstants.primary,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                hintText: "Search",
                hintStyle: inputHintTextStyle,
                enabledBorder: standardBorder,
                focusedBorder: standardBorder,
              ),
              style: inputTextStyle,
              controller: searchController,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search, color: searched? colorConstants.primary: colorConstants.tertiary, size: 30),
          onPressed: search,
        ),
        searched?
        IconButton(
          icon: Icon(Icons.clear, color: colorConstants.tertiary, size: 30),
          onPressed: removeSearch,
        ):
        Container()
      ],
    );
  }
}
