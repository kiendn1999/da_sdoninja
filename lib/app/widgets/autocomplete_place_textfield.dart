import 'package:da_sdoninja/app/constant/theme/app_radius.dart';
import 'package:da_sdoninja/app/data/model/place_details_model.dart';
import 'package:da_sdoninja/app/data/model/prediction.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  ItemClick? itmClick;
  GetPlaceDetailswWithLatLng? getPlaceDetailWithLatLng;
  bool isLatLngRequired = true;

  TextStyle textStyle;
  double? radius;
  double? iconHeight;
  double? marginTop;
  String googleAPIKey;
  String? hintText;
  String? initialValue;
  String? Function(String?)? validator;
  TextAlign? textAlign;
  Widget? suffixIcon;
  EdgeInsetsGeometry? contentPadding;
  int debounceTime = 600;
  List<String>? countries = [];
  TextEditingController textEditingController = TextEditingController();

  GooglePlaceAutoCompleteTextField({
    Key? key,
    required this.textEditingController,
    required this.googleAPIKey,
    this.debounceTime = 600,
    this.itmClick,
    this.hintText,
    this.radius = 10,
    this.contentPadding,
    this.iconHeight = 0.0,
    this.marginTop = 0.0,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.isLatLngRequired = true,
    this.textStyle = const TextStyle(),
    this.countries,
    this.validator,
    this.suffixIcon,
    this.getPlaceDetailWithLatLng,
  }) : super(key: key);

  @override
  _GooglePlaceAutoCompleteTextFieldState createState() => _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState extends State<GooglePlaceAutoCompleteTextField> {
  final subject = PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> alPredictions = [];

  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: textFormFieldApp(
        style: widget.textStyle,
        radius: widget.radius!,
        controller: widget.textEditingController,
        iconHeight: widget.iconHeight!,
        marginTop: widget.marginTop!,
        textAlign: widget.textAlign!,
        initialValue: widget.initialValue,
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        onChanged: (string) => (subject.add(string)),
        validator: widget.validator,
      ),
    );
  }

  getLocation(String text) async {
    Dio dio = Dio();
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}";

    if (widget.countries != null) {
      // in

      for (int i = 0; i < widget.countries!.length; i++) {
        String country = widget.countries![i];

        if (i == 0) {
          url = url + "&components=country:$country";
        } else {
          url = url + "|" + "country:" + country;
        }
      }
    }

    Response response = await dio.get(url);
    PlacesAutocompleteResponse subscriptionResponse = PlacesAutocompleteResponse.fromJson(response.data);

    if (text.isEmpty) {
      alPredictions.clear();
      _overlayEntry?.remove();
      return;
    }

    isSearched = false;
    if (subscriptionResponse.predictions!.isNotEmpty) {
      alPredictions.clear();
      alPredictions.addAll(subscriptionResponse.predictions!);
    }

    //if (this._overlayEntry == null)

    _overlayEntry = null;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    //   this._overlayEntry.markNeedsBuild();
  }

  @override
  void initState() {
    subject.stream.distinct().debounceTime(Duration(milliseconds: widget.debounceTime)).listen(textChanged);
  }

  textChanged(String text) async {
    getLocation(text);
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
          builder: (context) => Positioned(
                left: offset.dx,
                top: size.height + offset.dy,
                width: size.width,
                child: CompositedTransformFollower(
                  showWhenUnlinked: false,
                  link: _layerLink,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      elevation: 1.0,
                      borderRadius: BorderRadius.circular(AppRadius.radius10),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: alPredictions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (index < alPredictions.length) {
                                widget.itmClick!(alPredictions[index]);
                                if (!widget.isLatLngRequired) return;

                                getPlaceDetailsFromPlaceId(alPredictions[index]);

                                removeOverlay();
                              }
                            },
                            child: Container(padding: const EdgeInsets.all(10), child: Text(alPredictions[index].description!)),
                          );
                        },
                      )),
                ),
              ));
    }
  }

  removeOverlay() {
    alPredictions.clear();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
    _overlayEntry!.markNeedsBuild();
  }

  Future<Response?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    //String key = GlobalConfiguration().getString('google_maps_key');

    var url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${widget.googleAPIKey}";
    Response response = await Dio().get(
      url,
    );

    PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

    prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
    prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

    widget.getPlaceDetailWithLatLng!(prediction);

//    prediction.latLng = new LatLng(
//        placeDetails.result.geometry.location.lat,
//        placeDetails.result.geometry.location.lng);
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) {
  return PlacesAutocompleteResponse.fromJson(responseBody as Map<String, dynamic>);
}

PlaceDetails parsePlaceDetailMap(Map responseBody) {
  return PlaceDetails.fromJson(responseBody as Map<String, dynamic>);
}

typedef ItemClick = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailswWithLatLng = void Function(Prediction postalCodeResponse);
