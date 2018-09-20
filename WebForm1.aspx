<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication6.WebForm1"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>CMLUCA - Military Bases and Airspace in California</title>

    <link rel="stylesheet" href="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/dojo/dijit/themes/claro/claro.css"/>
        <link rel="stylesheet" href="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/esri/css/esri.css"/>
   <!-- <link rel="stylesheet" href="http://js.arcgis.com/3.9/js/dojo/dijit/themes/claro/claro.css"/>    
    <link rel="stylesheet" href="http://js.arcgis.com/3.9/js/esri/css/esri.css"/>-->

        <link rel="stylesheet" href="Content/Site.css" />
    <link href="Content/accordion.css" rel="stylesheet"/>
     
<style> 
     
      /*.esriBasemapGallerySelectedNode .esriBasemapGalleryThumbnail{
        border-color: #66FFFF !important;
      }*/
      
    </style> 
    
   <!--  <script type="text/javascript" src="/jsapi_vsdoc12_v35.js"></script>-->
    

     <%-- <script src="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5"></script>--%>
    <%--<script src="dojo1.7/dojo/dojo.js" data-dojo-config="async: true, parseOnLoad: true">--%>
    <script src="http://js.arcgis.com/3.5/"></script>
        <script>
            dojo.require("esri.map");
            dojo.require("esri.tasks.locator");
            dojo.require("esri.layers.ArcGISDynamicMapServiceLayer");
            dojo.require("esri.layers.ArcGISTiledMapServiceLayer");
            dojo.require("esri.dijit.BasemapGallery");
            dojo.require("dijit.layout.BorderContainer");
            dojo.require("esri.tasks.identify");
            dojo.require("esri.arcgis.utils");
            dojo.require("dojo.parser");
            dojo.require("dojo.domReady!");
            dojo.require("dojo.dom");
           
            dojo.require("dojo._base.array");
           
            dojo.require("esri.tasks.query");
            dojo.require("esri.tasks.QueryTask");
            dojo.require("esri.symbols.SimpleFillSymbol");
            dojo.require("esri.symbols.SimpleLineSymbol");
            dojo.require("esri.graphic");
            dojo.require("esri.SpatialReference");
            dojo.require("esri.tasks.geometry");
            dojo.require("dijit.form.Slider");
            dojo.require("esri.tasks.BufferParameters");
            dojo.require("esri.tasks.GeometryService");

            var xmn;
            var xmx;
            var ymn;
            var ymx;

          


            //var app = {};
            //var map, locator, geom, geom2, QT, QTAir, zoomextent, QTBase, QTSpecial, QCounty, QSpecial, QAir, QBase, symbol, counter, identifyTask, msgInstallations, identifyParams, msgSpecialAir, circleSymb, msgTrainingRoutes;
            var map, locator, Branches, address, slider, selectedvalue, passaddress, PtX, PtY, geom, geom1000, clickpoint, msgroutes, msginstall, msgsu, sender, geom4000, gsvc, geom2, doBuffer, params, QT, zoomextent, QCounty, symbol, counter, identifyTask, BufferParameters, msgInstallations, identifyParams, msgSpecialAir, msgAction, circleSymb, msgTrainingRoutes;
            var msgTrainingRoutes4000, msgroutes4000, msgInstallations4000, msginstall4000, newcounter, msgSpecialAir4000, msgsu4000, result1000, result4000;
            //  dojo.ready(
            function init() {
                /// <summary>
                /// Initializes the map for the first time.
                /// </summary>
                //var popup = new esri.dijit.Popup({
                //    fillSymbol: new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0]), 2), new dojo.Color([255, 255, 0, 0.25]))
                //}, dojo.create("div"));


              



                map = new esri.Map("map", {
                    basemap: "gray",
                    center: [-120.500, 37.455],
                    zoom: 6,

                    logo: false
                });

                map.on("click", function (evt) {



                    geom2 = evt.mapPoint;
                    PtX = geom2.x;
                    PtY = geom2.y;

                    document.getElementById("lblx").innerHTML = geom2.x;
                    document.getElementById("lbly").innerHTML = geom2.y;
                    passaddress = undefined;
                   
                    doBuffer();



                   

                });


                

             

                //QT = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/Boundaries/CA_Counties/MapServer/0");

                sender = "county";
                params = new esri.tasks.BufferParameters();              

                gsvc = new esri.tasks.GeometryService("http://services.gis.ca.gov/arcgis/rest/services/Utilities/Geometry/GeometryServer");

                esriConfig.defaults.io.proxyUrl = "/arcgisserver/apis/javascript/proxy/proxy.ashx";
                esriConfig.defaults.io.alwaysUseProxy = false;

                var basemapGallery = new esri.dijit.BasemapGallery({
                    showArcGISBasemaps: true,
                    map: map

                }, "basemapGallery");




                var selectionHandler = dojo.connect(basemapGallery, "onSelectionChange", function () {
                    dojo.disconnect(selectionHandler);

                });
                basemapGallery.startup();

                dojo.connect(basemapGallery, "onError", function (msg) { console.log(msg) });



                var Branches = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.gis.ca.gov/ArcGIS/rest/services/IntelligenceMilitary/MilitaryInstallations/MapServer", { "opacity": 0.75 });

         
                map.addLayer(Branches);

                var Paths = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.gis.ca.gov/ArcGIS/rest/services/IntelligenceMilitary/MilitaryTrainingFlightRoutes/MapServer", { "opacity": 0.75 });
          
                map.addLayer(Paths);

                var airspace = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.gis.ca.gov/ArcGIS/rest/services/IntelligenceMilitary/MilitarySpecialUseAirspace/MapServer", { "opacity": 0.75 });
             
                map.addLayer(airspace);

                var counties = new esri.layers.ArcGISDynamicMapServiceLayer("http://services.gis.ca.gov/ArcGIS/rest/services/Boundaries/CA_Counties/MapServer");
                
                map.addLayer(counties);

               

                identifyTask = new esri.tasks.IdentifyTask("http://services.gis.ca.gov/arcgis/rest/services/IntelligenceMilitary/CMLUCA/MapServer");

                dojo.doc.getElementById("header").style.backgroundImage = "url('Images/header.png')";
                dojo.doc.getElementById("body").style.backgroundImage = "url('Images/Blueback.png')";
               

                locator = new esri.tasks.Locator("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer");
                dojo.connect(locator, "onAddressToLocationsComplete", showResults);



                var slider = new dijit.form.HorizontalSlider({
                    name: "slider",
                    value: 7,
                    minimum: 0,
                    maximum: 10,
                    intermediateChanges: true,
                    discreteValues: 11,
                    showButtons: true,
                    style: "width:250px;",
                    onChange: function (value) {
                        Branches.setOpacity(value / 10);
                        //dojo.byId("opval").innerHTML = value / 10;
                    }
                }, "slider");

                var slider2 = new dijit.form.HorizontalSlider({
                    name: "slider2",
                    value: 7,
                    minimum: 0,
                    maximum: 10,
                    intermediateChanges: true,
                    discreteValues: 11,
                    showButtons: true,
                    style: "width:250px;",
                    onChange: function (value) {
                        Paths.setOpacity(value / 10);
                        //dojo.byId("opval").innerHTML = value / 10;
                    }
                }, "slider2");

                var slider3 = new dijit.form.HorizontalSlider({
                    name: "slider3",
                    value: 7,
                    minimum: 0,
                    maximum: 10,
                    intermediateChanges: true,
                    discreteValues: 11,
                    showButtons: true,
                    style: "width:250px;",
                    onChange: function (value) {
                        airspace.setOpacity(value / 10);
                        //dojo.byId("opval").innerHTML = value / 10;
                    }
                }, "slider3");


                //map.reposition();
                //map.infoWindow.resize(200, 125);
            }
            //   );



            function Button_Click() {



                if (dojo.doc.getElementById("basemaps").style.visibility = "hidden") {
                    dojo.doc.getElementById("basemaps").style.visibility = "visible";
                    return false;
                }

               
               

                if (dojo.doc.getElementById("basemaps").style.visibility = "hidden") {
                    dojo.doc.getElementById("basemaps").style.visibility = "visible";
                    return false;
                }



            }

            function Label_Reset() {

                msgInstallations = "No Military Installations";
                msgSpecialAir = "No Special Air";
                msgTrainingRoutes = "No Training Routes";
                msgInstallations4000 = "No Military Installations";
                msgSpecialAir4000 = "No Special Air";
                msgTrainingRoutes4000 = "No Training Routes";
                document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;
               

            }

            function CountyZoom() {


               
                
                Label_Reset(); 
                selectedvalue = dojo.byId("CountyDD").value;
               
                map.graphics.clear();
                

                if (sender=="city") {
                    QT = new esri.tasks.QueryTask("http://services.gis.ca.gov/ArcGIS/rest/services/Government/CACounties10/MapServer/0");
                    QCounty = new esri.tasks.Query();

                    QCounty.returnGeometry = true;
                    //QCounty.where = "POLYGON_NM = '" + selectedvalue + "'";

                }

                else if (sender=="county") {
                    QT = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/Boundaries/CA_Counties/MapServer/0");
                    QCounty = new esri.tasks.Query();

                    QCounty.returnGeometry = true;
                    //QCounty.where = "POLYGON_NM = '" + selectedvalue + "'";
                }


               
               
                //QCounty = new esri.tasks.Query();

                //QCounty.returnGeometry = true;
                //QCounty.where = "POLYGON_NM = '" + selectedvalue + "'";
                QCounty.where = "POLYGON_NM = '" + selectedvalue + "'";
                QT.execute(QCounty, CountyQuery);


                
               
                


            }

            function CountyQuery(results) {

               
                var resultItems = [];
                var resultCount = results.features.length;
                var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL).setColor(new dojo.Color([238, 28, 36]));

                var geom5 = results.features[0].geometry;
                var graphic = new esri.Graphic(geom5, highlightSymbol);

               
               
                map.graphics.add(graphic);

                dojo.doc.getElementById("results2").style.visibility = "hidden";
                dojo.doc.getElementById("result2").style.visibility = "hidden";
                dojo.doc.getElementById("result4000").style.visibility = "hidden";
                dojo.doc.getElementById("results").style.visibility = "visible";
                dojo.doc.getElementById("btnclosewin").style.visibility = "visible";

                var zoomextent = results.features[0].geometry.getExtent().expand(1.5);
                map.setExtent(zoomextent);

                msgsu4000 = "";
                msginstall4000 = "";
                msgroutes4000 = "";
                msgTrainingRoutes = "is outside boundary";
                msginstall = "";
                msgSpecialAir = "is outside boundary";
                msgsu = "";
                msgInstallations = "is outside boundary";
                msgroutes = "";
                PtX = undefined;
                PtY = undefined;
                passaddress = undefined;
            

                identifyParams = new esri.tasks.IdentifyParameters();
                identifyParams.geometry = geom5;
                identifyParams.tolerance = 0;
                identifyParams.returnGeometry = false;
                identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;               
                identifyParams.mapExtent = map.extent;

                msgAction = "No Action Required";

                var deferred = identifyTask.execute(identifyParams);
                deferred.addCallback(function (response) {

                    for (var i in response) {


                        var conflict = response[i].layerName;

                        if (conflict == "Military Training Flight Routes") {


                            msgTrainingRoutes = "is inside boundary";
                            msgTrainingRoutes = msgTrainingRoutes.fontsize(2).bold();
                            msgAction = "Action Required";
                            msgroutes= "Training  Routes"
                         
                        }

                        if (conflict == "Military Installations") {
                            msgInstallations = "is inside boundary";
                            msgInstallations = msgInstallations.fontsize(2).bold();
                            msgAction = "Action Required";
                            msginstall = "Military Installations";


                        }

                        if (conflict == "Military Special Use Airspace") {
                            msgSpecialAir = "is inside boundary";
                            msgSpecialAir = msgSpecialAir.fontsize(2).bold();
                            msgAction = "Action Required";
                            msgsu = "Special Use Air";

                        }

                    }

                    document.getElementById("countyname").innerHTML = "Report for: " + selectedvalue;
                   
                    document.getElementById("result").innerHTML = "Flight Path:"+ "  " + msgTrainingRoutes + "<br>" + "Military Base: " + msgInstallations + "<br>" + "Air Space:"+ "     " + msgSpecialAir + "<br>";
                    //document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;
                    sender = "";




                });


            }


            function closemaps() {

                dojo.doc.getElementById("basemaps").style.visibility = "hidden";
                

            }

            function doFind() {

                //alert("Here we are");
                msgInstallations = "No Military Installations";
                msgSpecialAir = "No Special Air";
                msgTrainingRoutes = "No Training Routes";
                msgInstallations4000 = "No Military Installations";
                msgSpecialAir4000 = "No Special Air";
                msgTrainingRoutes4000 = "No Training Routes";

                document.getElementById("result4000").innerHTML = "Flight Path:     " + msgTrainingRoutes4000 + "<br>" + "Military Base: " + msgInstallations4000 + "<br>" + "Air Space:         " + msgSpecialAir4000;
                document.getElementById("result2").innerHTML = "Flight Path:     " + msgTrainingRoutes + "<br>" + "Military Base: " + msgInstallations + "<br>" + "Air Space:         " + msgSpecialAir + "<br>";
               

                map.graphics.clear();
                message = "";
                document.getElementById("lblx").innerHTML = "";
                document.getElementById("lbly").innerHTML = "";
                //x = undefined;
                //y = undefined;

                //var address = { "SingleLine": dojo.byId("address").value };
                address = { "SingleLine": dojo.byId("searchText").value };
                locator.outSpatialReference = map.spatialReference;
                var options = {
                    address: address,
                    outFields: ["Loc_name"]
                }

                passaddress = dojo.byId("searchText").value;
                locator.addressToLocations(options);


               doBuffer();
               identify1000();

            }

            function PrintWindow() {

              

                var xmn = map.extent.xmin;
                var xmx = map.extent.xmax;
                var ymn = map.extent.ymin;
                var ymx = map.extent.ymax;
                var resultmatch;
                var y = document.getElementById("radCity").checked;

                if (result1000 == result4000) {

                    resultmatch = "yes";

                }
                else {
                    resultmatch = "no";
                }

             


                
                window.open("http://cmluca.gis.ca.gov/WebForm2.aspx?&Xmax=" + xmx + "&Xmin=" + xmn + "&Ymin=" + ymn + "&Ymax=" + ymx + "&county=" + selectedvalue + "&action=" + msgAction + "&su=" + msgsu + "&mi=" + msginstall + "&fr=" + msgroutes + "&x=" + PtX + "&y=" + PtY + "&ad=" + passaddress + "&Q4000=" + resultmatch + "&Air4000=" + msgsu4000 + "&Base4000=" + msginstall4000 + "&Routes4000=" + msgroutes4000 + "&BoxCheck=" + y);   //+ "&BStreet=" + BusStreet + "&BCity=" + BusCity + "&BZip=" + BusZip + "&OwnName=" + OName + "&BizName=" + BName + "&LayerName=Nothing" + "&GEOM=PT");

                //window.open("http://localhost:49941/WebForm2.aspx?&Xmax=" + xmx + "&Xmin=" + xmn + "&Ymin=" + ymn + "&Ymax=" + ymx + "&county=" + selectedvalue + "&action=" + msgAction + "&su=" + msgsu + "&mi=" + msginstall + "&fr=" + msgroutes + "&x=" + PtX + "&y=" + PtY + "&ad=" + passaddress + "&Q4000=" + resultmatch + "&Air4000=" + msgsu4000 + "&Base4000=" + msginstall4000 + "&Routes4000=" + msgroutes4000 + "&BoxCheck=" + y);   //+ "&BStreet=" + BusStreet + "&BCity=" + BusCity + "&BZip=" + BusZip + "&OwnName=" + OName + "&BizName=" + BName + "&LayerName=Nothing" + "&GEOM=PT");

            }


            function showResults(candidates) {
                var candidate;
                //var symbol = new esri.symbol.SimpleMarkerSymbol();
                var symbol = new esri.symbol.PictureMarkerSymbol('Images/FlagRed32.png', 50, 50);
                //var infoTemplate = new esri.InfoTemplate("Location", "Address: ${address}<br />Score: ${score}<br />Source locator: ${locatorName}");
                //var template = new esri.InfoTemplate("Tax Rate:", "Rate: ${Rate} Tax Area: ${City}");
                //symbol.setStyle(esri.symbol.SimpleMarkerSymbol.STYLE_FLAG);

                //symbol.setColor(new dojo.Color([153, 0, 51, 0.75]));

                //var geom;

                dojo.every(candidates, function (candidate) {


                    console.log(candidate.score);
                    if (candidate.score > 80) {
                        console.log(candidate.location);
                        var attributes = { address: candidate.address, score: candidate.score, locatorName: candidate.attributes.Loc_name };
                        geom2 = candidate.location;
                        var graphic = new esri.Graphic(geom2, symbol);
                        PtX = geom2.x;
                        PtY = geom2.y;
                        //add a graphic to the map at the geocoded location
                        map.graphics.add(graphic);
                        //add a text symbol to the map listing the location of the matched address.
                        //var displayText = candidate.address;
                        //var font = new esri.symbol.Font("16pt", esri.symbol.Font.STYLE_NORMAL, esri.symbol.Font.VARIANT_NORMAL, esri.symbol.Font.WEIGHT_BOLD, "Helvetica");

                        //var textSymbol = new esri.symbol.TextSymbol(displayText, font, new dojo.Color("#666633"));
                        //textSymbol.setOffset(0, 8);
                        //map.graphics.add(new esri.Graphic(geom2));
                        map.centerAndZoom(geom2, 16);
                        //document.getElementById("ReturnVal").innerHTML = candidate.address;;

                        //message = "The tax ratefor the address you entered is displayed on the left side of the screen.Please be aware that tax rates, as well as city and county boundary lines, are subject to change.The rate displayed on the screen, based upon the address you provided, is the rate in effect today.";
                        //document.getElementById('text').innerHTML = message;

                        //gsvc.on("buffer-complete", AddBuffer());



                        return false; //break out of loop after one candidate with score greater  than 80 is found.


                    }


                });


                //geom2 = null;

            }

            function identify1000() {
                

                dojo.doc.getElementById("results2").style.visibility = "visible";
                dojo.doc.getElementById("result2").style.visibility = "visible";
                dojo.doc.getElementById("result4000").style.visibility = "visible";
                dojo.doc.getElementById("results").style.visibility = "hidden";
                dojo.doc.getElementById("btnclosewin").style.visibility = "hidden";

                if (document.getElementById("lblx").innerHTML == "") {
                    document.getElementById("lblx").innerHTML = passaddress;
                    document.getElementById("lbly").innerHTML = "";

                }

               
                identifyParams = new esri.tasks.IdentifyParameters();
                identifyParams.geometry = geom1000;
                identifyParams.tolerance = 0;
                identifyParams.returnGeometry = false;
                //identifyParams.layerIds = [0, 1];
                identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
                //identifyParams.width = map.width;
                //identifyParams.height = map.height;

                identifyParams.mapExtent = map.extent;

                msgAction = "No Action Required";

               
                


                var deferred2 = identifyTask.execute(identifyParams);
                //alert("getting results...");
                deferred2.addCallback(function (response) {

                  

                    for (var i in response) {

                        
                        //alert(newcounter);

                        var conflict = response[i].layerName;

                        if (conflict == "Military Training Flight Routes") {


                            msgTrainingRoutes = "is within 1000 feet";
                            msgTrainingRoutes = msgTrainingRoutes.fontsize(2).bold();
                            msgroutes = "Training Routes"
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Installations") {
                            msgInstallations = "is within 1000 feet";
                            msgInstallations = msgInstallations.fontsize(2).bold();
                            msginstall = "Military Installations";
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Special Use Airspace") {
                            msgSpecialAir = "is within 1000 feet";
                            msgSpecialAir = msgSpecialAir.fontsize(2).bold();
                            msgsu = "Special Use Airspace";
                            msgAction = "Action Required";

                        }

                        result1000 = "yes";

                    }




                    //document.getElementById("result").innerHTML = "Flight Path:     " + msgTrainingRoutes + "<br>" + "Military Base: " + msgInstallations + "<br>" + "Air Space:         " + msgSpecialAir + "<br>";
                    //document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;

                    document.getElementById("result2").innerHTML = "Flight Path:     " + msgTrainingRoutes + "<br>" + "Military Base: " + msgInstallations + "<br>" + "Air Space:         " + msgSpecialAir + "<br>";



                });

                identify4000();

               

            }

            function closediv() {

                dojo.doc.getElementById("results").style.visibility = "hidden";
                dojo.doc.getElementById("btnclosewin").style.visibility = "hidden";

            }

            function identify4000() {
               
                dojo.doc.getElementById("result4000").style.visibility = "visible";
                identifyParams = new esri.tasks.IdentifyParameters();
                identifyParams.geometry = geom4000;
                identifyParams.tolerance = 0;
                identifyParams.returnGeometry = false;
                //identifyParams.layerIds = [0, 1];
                identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
                //identifyParams.width = map.width;
                //identifyParams.height = map.height;

                identifyParams.mapExtent = map.extent;

                msgAction = "No Action Required";

                var deferred = identifyTask.execute(identifyParams);
                //alert("getting results...");
                deferred.addCallback(function (response) {

                    for (var i in response) {


                        var conflict = response[i].layerName;

                        if (conflict == "Military Training Flight Routes") {


                            msgTrainingRoutes4000 = "is within 4000 feet";
                            msgTrainingRoutes4000 = msgTrainingRoutes4000.fontsize(2).bold();
                            msgroutes4000 = "Training Routes within 4000 feet"
                           
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Installations") {
                            msgInstallations4000 = "is within 4000 feet";
                            msgInstallations4000 = msgInstallations4000.fontsize(2).bold();
                            msginstall4000 = "Military Installations within 4000 feet";
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Special Use Airspace") {
                            msgSpecialAir4000 = "is within 4000 feet";
                            msgSpecialAir4000 = msgSpecialAir4000.fontsize(2).bold();
                            msgsu4000 = "Special Use Airspace within 4000 feet";
                            msgAction = "Action Required";

                        }
                        result4000 = "yes";
                    }




                    //document.getElementById("result").innerHTML = "Flight Path:     " + msgTrainingRoutes + "<br>" + "Military Base: " + msgInstallations + "<br>" + "Air Space:         " + msgSpecialAir + "<br>";
                    document.getElementById("result4000").innerHTML = "Flight Path:     " + msgTrainingRoutes4000 + "<br>" + "Military Base: " + msgInstallations4000 + "<br>" + "Air Space:         " + msgSpecialAir4000;





                });


            }


            function Branches() {
               
               

                map.removeLayer(Branches);
            }

            function doBuffer() {

                alert("Creating 1000 & 4000 foot buffers");
                //var params = new esri.tasks.BufferParameters();
                //Label_Reset();

                map.graphics.clear();

                msgInstallations = "is outside 1000 feet";
                msgSpecialAir = "is outside 1000 feet";
                msgTrainingRoutes = "is outside 1000 feet";
                msgInstallations4000 = "is outside 4000 feet";
                msgSpecialAir4000 = "is outside 4000 feet";
                msgTrainingRoutes4000 = "is outside 4000 feet";

                msgsu4000 = "";
                msginstall4000 = "";
                msgroutes4000 = "";
                msginstall = "";
                msgsu = "";             
                msgroutes = "";
                selectedvalue = undefined;
              
               




                params.geometries = [geom2];

                //buffer in linear units such as meters, km, miles etc.
                params.distances = [1000, 4000];
                params.unit = esri.tasks.GeometryService.UNIT_FOOT;
                params.outSpatialReference = map.spatialReference;

                gsvc.buffer(params, showBuffer);
            }

            function Instructions_Click() {

               // window.open("http://localhost:49941/HtmlPage3.html", "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=700, height=500");
                window.open("http://cmluca.gis.ca.gov/HtmlPage3.html", "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=700, height=500");
               

            }

            function radclicked() {
                //alert("radclicked");

                var x = document.getElementById("radCity").checked;
                if (x == true) {
                    queryTask = new esri.tasks.QueryTask ("http://services.gis.ca.gov/ArcGIS/rest/services/Government/CACounties10/MapServer/0");
                    sender = "city";
                }

                if (x == false) {
                    queryTask = new esri.tasks.QueryTask("http://services.gis.ca.gov/ArcGIS/rest/services/Government/CACounties10/MapServer/1");
                    sender = "county";
                }

               

                query = new esri.tasks.Query();
                query.returnGeometry = false;
                query.outFields = ["POLYGON_NM"];
                query.where = "POLYGON_NM <> ''";
                queryTask.execute(query, populateList);
               






            }

            function populateList(results) {
                //Populate the ComboBox with unique values
                
               
                
                
                
                var zone;
                var values = [];
                var testVals = {};

                var x = 0;

                for (feature in results.features) {

                    values.push(results.features[x].attributes["POLYGON_NM"]);


                    //alert(results.features[x].attributes["POLYGON_NM"]);
                    x = x + 1;

                }
                values.sort();

                var select = document.getElementById("CountyDD");

                //select.options = null;
                //var length = select.options.length;


                //for (i = 0; i < length; i++) {
                //    select.options[i] = null;
                    
                //}
                while (select.options.length > 0) {
                    select.remove(0);
                }



                //var newOption = document.createElement('<option value="TOYOTA">');
                //document.all.mySelect.options.add(newOption);
                //newOption.innerText = "Toyota";


                //Add option to display all zoning types to the ComboBox
                //values.push({ name: "ALL" })

                //Loop through the QueryTask results and populate an array
                //with the unique values
                //var features = results.features;

              
                //dojo.forEach(features, function (feature) {
                //    zone = feature.attributes.POLYGON_NM;
                //    //var newOption = document.createElement('<option value="TOYOTA">');
                //    var newOption = document.createElement("option");
                //    document.getElementById("CountyDD").options.add(newOption);
                //    newOption.text = zone;
                //    newOption.value = zone;
                   
                //});
                var arraylength = values.length;

                for (var i = 0; i < arraylength; i++) {
                    var newOption = document.createElement("option");
                    document.getElementById("CountyDD").options.add(newOption);
                    newOption.text = values[i];
                    newOption.value = values[i];

                }




                //Create a ItemFileReadStore and use it for the
                //ComboBox's data source
                //var dataItems = {
                //    identifier: 'name',
                //    label: 'name',
                //    items: values
                //};
                //var store = new dojo.data.ItemFileReadStore({ data: dataItems });
                //dijit.byId("CountyDD").store = store;
            }



            function showBuffer(geometries) {
                var symbol = new esri.symbol.SimpleFillSymbol(
                  esri.symbol.SimpleFillSymbol.STYLE_SOLID,
                  new esri.symbol.SimpleLineSymbol(
                    esri.symbol.SimpleLineSymbol.STYLE_SOLID,
                    new dojo.Color([0, 0, 255, 0.65]), 2
                  ),
                  new dojo.Color([0, 0, 255, 0.35])
                );


                geom1000 = geometries[0];
                geom4000 = geometries[1];

                var graphic = new esri.Graphic(geom1000, symbol);
                var graphic2 = new esri.Graphic(geom4000, symbol);

                map.graphics.add(graphic);
                map.graphics.add(graphic2);


                var zoomextent2 = geom4000.getExtent().expand(1.5);
                
                map.setExtent(zoomextent2);
                identify1000();
                counter = 0;
               
            }

            

            dojo.ready(init);
            


        </script>

    







</head>
  <body class="claro" id="body">

   
        <form id="Form1"  runat="server" style="height: 100%;">

           
           
            <div class="container"> <!--style:"box-shadow"-->



                <div class="header" id="header">
                    <div id="searchlinks">
<a href="http://www.ca.gov/" target="_blank"  class="CALink">CA.gov</a>  <a href="http://opr.ca.gov/planning/land-use/military-affairs/" target="_blank"   class="MilLink">OPR Military Affairs</a>  <a href="AppDocuments/CMLUCA Notification List_8-2018.pdf"  target="_blank"  class="ConLink" >Noticication Contact List</a>

			</div>

                    
                </div>
                
                <div class="body">
                    <div class="toolbar">
                            
                            <button id="btnbase" onclick="Button_Click();return false">Select Basemap</button> 
                            <button id="btnInstructions" onclick="Instructions_Click();return false">Instructions</button> 

                            <button id="btnPrint" onclick="PrintWindow();return false">Print Report</button> 



                            <label id="lblCounty">Select a County or City<br />
                             <select id="CountyDD" onchange="CountyZoom()">
                <option value="Alameda">Alameda</option>
                <option value="Alpine">Alpine</option>
                <option value="Amador">Amador</option>
                <option value="Butte">Butte</option>
                <option value="Calaveras ">Calaveras </option>
                <option value="Contra Costa">Contra Costa  </option>
                <option value="Del Norte">Del Norte</option>

                <option value="El Dorado">El Dorado</option>
                <option value="Fresno">Fresno</option>
                <option value="Glenn">Glenn</option>
                <option value="Humboldt">Humboldt</option>
                <option value="Imperial">Imperial</option>
                <option value="Inyo">Inyo</option>
                <option value="Kern">Kern</option>
                <option value="Kings">Kings</option>
                <option value="Lake">Lake</option>
                <option value="Lassen">Lassen</option>
                <option value="Los Angeles">Los Angeles</option>
                <option value="Madera">Madera</option>
                <option value="Marin">Marin</option>
                <option value="Mariposa">Mariposa</option>
                <option value="Mendocino">Mendocino</option>
                <option value="Merced">Merced</option>
                <option value="Modoc">Modoc</option>
                <option value="Mono">Mono</option>
                <option value="Monterey">Monterey</option>
                <option value="Napa">Napa</option>
                <option value="Nevada">Nevada</option>
                <option value="Orange">Orange</option>
                <option value="Placer">Placer</option>
                <option value="Plumas">Plumas</option>
                <option value="Riverside">Riverside</option>
                <option value="Sacramento">Sacramento</option>
                <option value="San Benito">San Benito</option>
                <option value="San Bernardino">San Bernardino</option>
                <option value="San Diego">San Diego</option>
                <option value="San Francisco">San Francisco</option>
                <option value="San Joaquin">San Joaquin</option>
                <option value="San Luis Obispo">San Luis Obispo</option>
                <option value="San Mateo">San Mateo</option>
                <option value="Santa Barbara">Santa Barbara</option>
                <option value="Santa Clara">Santa Clara</option>
                <option value="Santa Cruz">Santa Cruz </option>
                <option value="Shasta">Shasta</option>
                <option value="Sierra">Sierra</option>
                <option value="Siskiyou">Siskiyou</option>
                <option value="Solano">Solano</option>
                <option value="Sonoma">Sonoma</option>
                <option value="Stanislaus">Stanislaus</option>
                <option value="Sutter">Sutter</option>
                <option value="Tehama">Tehama</option>
                <option value="Trinity">Trinity</option>
                <option value="Tulare">Tulare</option>
                <option value="Tuolumne">Tuolumne</option>
                <option value="Ventura">Ventura</option>
                <option value="Yolo">Yolo</option>
                <option value="Yuba">Yuba </option>
               

              </select>
              </label>
     <input type="checkbox" id="radCity"  onclick="radclicked()" value="City" />
     <label id="lblFind">Find Address: <input type="text" id="searchText" size="40" value=""/></label>
     <input type="button" id="btnFind" value="Find" onclick="doFind()" />


                           

                        </div>
<div class="leftPane">
                       

<section>
<a id="intro">
<h1><input type="checkbox" name="mb" checked="checked" "/>  Military Bases</h1>
    


</a>
<p>
    <div id="slider">             
</div>
    <img src='Images/Branches.png' />
   
</p>
    
</section>


<section>
<a id="info">
 <h1><input type="checkbox"  checked="checked"  name="fp"/>  Flight Paths</h1>
   
</a>
<p>
    <div id="slider2">             
</div>
 <img src='Images/Paths.png'/>

</p>
    
</section>


<section>
<a id="airspace">
    
 <h1><input type="checkbox"  checked="checked"  name="as"/>  Air Space</h1>
</a>
<p>
    <div id="slider3">             
</div>
<img src='Images/Airspace.png'/>

</p>
    
</section>
<%--<section>
<a href="#contact" id="contact">
<h1>County Boundaries</h1>
</a>
<p>
<img src='Images/Counties.png'/>

</p>
 </section>--%>
                           
                        </div>
                    </div>
                
                        
                    <div class="mapFrame" id="map">
                        
              

                    </div>

                    <div class="mapFooter">

                     
		Copyright &copy; 2010 State of California
	
                       
                    </div>

               



        <div id="basemaps"  style="position:absolute; z-index:0; visibility:hidden; left:75px; top:170px;">
            <button type="button" onclick="closemaps()" style="position:absolute; z-index:0; height:18px; width:12px; right:3px; top:3px;">x</button>

          <div data-dojo-type="dijit/TitlePane" 
               data-dojo-props="title:'Switch Basemap',  closable:true,  open:false">

            <div data-dojo-type="dijit/layout/ContentPane" style="width:380px; height:200px; background-color:white;">
            <div id="basemapGallery" ></div></div>
          </div>
        </div>



<div id="results"> 
    <button type="button" id="btnclosewin" onclick="closediv()" style="position:absolute; visibility:hidden; z-index:0; height:18px; width:12px; right:3px; top:3px;">x</button>
    <label id="countyname"></label><br />
    <br />
    <label id="result"></label>
   
</div>

<div id="results2"> 
    <button type="button" id="Button1" onclick="closediv()" style="position:absolute; visibility:hidden; z-index:0; height:18px; width:12px; right:3px; top:3px;">x</button>
     <label id="lblx"></label><br />
    <label id="lbly"></label><br />
    <br />
    <label id="result2"></label>
    <label id="result4000"></label>    
</div>



</div>

               
</form>

     

</body>
</html>
