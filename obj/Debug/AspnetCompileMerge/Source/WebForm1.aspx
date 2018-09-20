<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication6.WebForm1"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>CMLUCA</title>

    <link rel="stylesheet" href="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/dojo/dijit/themes/claro/claro.css"/>
        <link rel="stylesheet" href="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/esri/css/esri.css"/>
   <!-- <link rel="stylesheet" href="http://js.arcgis.com/3.9/js/dojo/dijit/themes/claro/claro.css"/>    
    <link rel="stylesheet" href="http://js.arcgis.com/3.9/js/esri/css/esri.css"/>-->

        <link rel="stylesheet" href="Content/Site.css" />
    <link href="Content/accordion.css" rel="stylesheet"/>
     <script type="text/javascript" src="JavaScript1.js"></script>
<style> 
     
      /*.esriBasemapGallerySelectedNode .esriBasemapGalleryThumbnail{
        border-color: #66FFFF !important;
      }*/
      
    </style> 
    
   <!--  <script type="text/javascript" src="/jsapi_vsdoc12_v35.js"></script>-->
    

      <!--<script src="http://serverapi.arcgisonline.com/jsapi/arcgis/3.5"></script>-->
    <script src="http://js.arcgis.com/3.9/"></script>
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
            
            dojo.require("esri.tasks.BufferParameters");
            dojo.require("esri.tasks.GeometryService");

            var xmn;
            var xmx;
            var ymn;
            var ymx;

          


            var app = {};
            //var map, locator, geom, geom2, QT, QTAir, zoomextent, QTBase, QTSpecial, QCounty, QSpecial, QAir, QBase, symbol, counter, identifyTask, msgInstallations, identifyParams, msgSpecialAir, circleSymb, msgTrainingRoutes;
            var map, locator, address, selectedvalue, passaddress, PtX, PtY, geom, geom1000, clickpoint, msgroutes, msginstall, msgsu, sender, geom4000, gsvc, geom2, doBuffer, params, QT, zoomextent, QCounty, symbol, counter, identifyTask, BufferParameters, msgInstallations, identifyParams, msgSpecialAir, msgAction, circleSymb, msgTrainingRoutes;

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
                    sender = "mapclick";
                    doBuffer()
                    //CountyQuery();

                });

                map.reposition();


                params = new esri.tasks.BufferParameters();

               


                gsvc = new esri.tasks.GeometryService("http://tasks.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer");

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

                var counties = new esri.layers.ArcGISDynamicMapServiceLayer("https://services.gis.ca.gov/ArcGIS/rest/services/Boundaries/CA_Counties/MapServer");
                
                map.addLayer(counties);


                identifyTask = new esri.tasks.IdentifyTask("http://services.gis.ca.gov/arcgis/rest/services/IntelligenceMilitary/CMLUCA/MapServer");

                app.QT = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/Boundaries/CA_Counties/MapServer/0");
                //app.QTAir = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/IntelligenceMilitary/MilitaryTrainingFlightRoutes/MapServer/0");
                //app.QTSpecial = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/IntelligenceMilitary/MilitarySpecialUseAirspace/MapServer/0");
                //app.QTBase = new esri.tasks.QueryTask("http://services.gis.ca.gov/arcgis/rest/services/IntelligenceMilitary/MilitaryInstallations/MapServer/0");

                app.QCounty = new esri.tasks.query();
                //app.QSpecial = new esri.tasks.query();
                //app.QBase = new esri.tasks.query();
                //app.QAir = new esri.tasks.query();

               

                locator = new esri.tasks.Locator("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer");
                dojo.connect(locator, "onAddressToLocationsComplete", showResults);

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
                document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;



            }

            function CountyZoom() {
                //alert("County Zoom");
                //msgInstallations == "No Military Installations";
                //msgSpecialAir == "No Special Air";
                //msgTrainingRoutes == "No Training Routes";
                //document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;
                //sender = "County";
               

                Label_Reset(); 
                selectedvalue = dojo.byId("CountyDD").value;
                map.graphics.clear();

              

                app.QCounty.returnGeometry = true;
                app.QCounty.where = "POLYGON_NM = '" + selectedvalue + "'";
                app.QT.execute(app.QCounty, CountyQuery);

                

                


            }

            function CountyQuery(results) {

                var resultItems = [];
                var resultCount = results.features.length;
                var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_FORWARD_DIAGONAL).setColor(new dojo.Color([238, 28, 36]));

                var geom5 = results.features[0].geometry;
                var graphic = new esri.Graphic(geom5, highlightSymbol);

               
               
                map.graphics.add(graphic);

                var zoomextent = results.features[0].geometry.getExtent().expand(1.5);
                map.setExtent(zoomextent);




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


                            msgTrainingRoutes = "This county contains military training flight routes";
                            msgAction = "Action Required";
                            msgroutes= "Training  Routes"
                         
                        }

                        if (conflict == "Military Installations") {
                            msgInstallations = "This county contains military installations";
                            msgAction = "Action Required";
                            msginstall = "Military Installations";


                        }

                        if (conflict == "Military Special Use Airspace") {
                            msgSpecialAir = "This county contains military special flight routes";
                            msgAction = "Action Required";
                            msgsu = "Special Use Air";

                        }

                    }



                    document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;
                    sender = "";




                });


            }


            function closemaps() {

                dojo.doc.getElementById("basemaps").style.visibility = "hidden";

            }

            function doFind() {

                //alert("Here we are");
                Label_Reset()
                map.graphics.clear();
                message = "";

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
             


                
                window.open("http://maps.gis.ca.gov/demos/WebApplication6/WebForm2.aspx?&Xmax=" + xmx + "&Xmin=" + xmn + "&Ymin=" + ymn + "&Ymax=" + ymx + "&county=" + selectedvalue + "&action=" + msgAction + "&su=" + msgsu + "&mi=" + msginstall + "&fr=" + msgroutes + "&x=" + PtX + "&y=" + PtY + "&ad=" + passaddress);   //+ "&BStreet=" + BusStreet + "&BCity=" + BusCity + "&BZip=" + BusZip + "&OwnName=" + OName + "&BizName=" + BName + "&LayerName=Nothing" + "&GEOM=PT");

                //window.open("http://localhost:49941/WebForm2.aspx?&Xmax=" + xmx + "&Xmin=" + xmn + "&Ymin=" + ymn + "&Ymax=" + ymx + "&county=" + selectedvalue + "&action=" + msgAction + "&su=" + msgsu + "&mi=" + msginstall + "&fr=" + msgroutes + "&x=" + PtX + "&y=" + PtY + "&ad=" + passaddress);   //+ "&BStreet=" + BusStreet + "&BCity=" + BusCity + "&BZip=" + BusZip + "&OwnName=" + OName + "&BizName=" + BName + "&LayerName=Nothing" + "&GEOM=PT");

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


                        var conflict = response[i].layerName;

                        if (conflict == "Military Training Flight Routes") {


                            msgTrainingRoutes = "This county contains military training flight routes";
                            msgroutes = "Training Routes"
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Installations") {
                            msgInstallations = "This county contains military installations";
                            msginstall = "Military Installations";
                            msgAction = "Action Required";

                        }

                        if (conflict == "Military Special Use Airspace") {
                            msgSpecialAir = "This county contains military special flight routes";
                            msgsu = "Special Use Airspace";
                            msgAction = "Action Required";

                        }

                    }





                    document.getElementById("result").innerHTML = msgTrainingRoutes + "<br>" + msgInstallations + "<br>" + msgSpecialAir;





                });


            }

            function doBuffer() {

                alert("buffering...");
                //var params = new esri.tasks.BufferParameters();
                Label_Reset();

                params.geometries = [geom2];

                //buffer in linear units such as meters, km, miles etc.
                params.distances = [1000, 4000];
                params.unit = esri.tasks.GeometryService.UNIT_FOOT;
                params.outSpatialReference = map.spatialReference;

                gsvc.buffer(params, showBuffer);
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

                //                    dojo.forEach(geometries, function (geometry) {
                //                        var graphic = new esri.Graphic(geometry, symbol);
                //                        map.graphics.add(graphic);
                //                    });
                var counter = 1;
           
                dojo.forEach(geometries, function (geometry) {
                    var counter = 1;
                    if (counter <= 2) {
                        if (counter == 1) {
                            var graphic = new esri.Graphic(geometry, symbol);
                            geom1000 = graphic.geometry;
                            map.graphics.add(graphic);
                            counter = counter + 1;
                        }
                        if (counter == 2) {
                            var graphic = new esri.Graphic(geometry, symbol);
                            geom4000 = graphic.geometry;
                            map.graphics.add(graphic);
                            counter = counter + 1;


                        }

                    }


                });

                var zoomextent2 = geom4000.getExtent().expand(1.5);
                
                map.setExtent(zoomextent2);
                identify1000();
            }


            dojo.ready(init);
            


        </script>

    







</head>
  <body class="claro">
        <form id="Form1"  runat="server" style="height: 100%;">

           
           
            <div class="container"> <!--style:"box-shadow"-->



                <div class="header">
                    <div id="searchlinks">
<a href="http://www.ca.gov/" class="CALink">CA.gov</a>  <a href="http://www.opr.ca.gov/s_military.php" class="MilLink">OPR Military Affairs</a>  <a href="http://cmluca.projects.atlas.ca.gov/SB1462_POClistupdated4_2013.html" class="ConLink" >Noticication Contact List</a>

			</div>

                    
                </div>
                
                <div class="body">
                    <div class="leftPane">
                       

                            <section>
 <a href="#intro" id="intro">
<h1>Military Bases</h1>
</a>
<p>
    <img src='Images/Branches.png' />
</p>
</section>
<section>
<a href="#info" id="info">
 <h1>Flight Paths</h1>
</a>
<p>
 <img src='Images/Paths.png'/>

</p>
</section>
<section>
<a href="#airspace" id="airspace">
 <h1>Air Space</h1>
</a>
<p>
<img src='Images/Airspace.png'/>

</p>
</section>
<section>
<a href="#contact" id="contact">
<h1>County Boundaries</h1>
</a>
<p>
<img src='Images/Counties.png'/>

</p>
 </section>
                           
                        </div>
                    </div>
                        
                    <div class="mapFrame" id="map">
                        
                        <div class="toolbar">
                            
                            <button id="btnbase" onclick="Button_Click();return false">Select Basemap</button> 

                            <button id="btnPrint" onclick="PrintWindow()">Print Report</button> 



                            <label id="lblCounty">Select a County:<br />
                             <select id="CountyDD" onchange="CountyZoom()">
                <option value="Alameda">Alameda</option>
                <option value="Alpine ">Alpine</option>
                <option value="Amador ">Amador</option>
                <option value="Butte ">Butte</option>
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

     <label id="lblFind">Find Address: <input type="text" id="searchText" size="40" value=""/></label>
     <input type="button" id="btnFind" value="Find" onclick="doFind()" />


                           

                        </div>

                    </div>

                    <div class="mapFooter">

                     
		Copyright &copy; 2010 State of California
	
                       
                    </div>

                <!--<div style="position:absolute; right:20px; top:10px; z-Index:999;">
          <div data-dojo-type="dijit/TitlePane" 
               data-dojo-props="title:'Switch Basemap', closable:false,  open:false">
            <div data-dojo-type="dijit/layout/ContentPane" style="width:380px; height:280px; overflow:auto;">
            <div id="basemapGallery" ></div></div>
          </div>
        </div>-->



        <div id="basemaps"  style="position:absolute; z-index:0; visibility:hidden; left:75px; top:170px;">
            <button type="button" onclick="closemaps()" style="position:absolute; z-index:0; height:18px; width:12px; right:3px; top:3px;">x</button>

          <div data-dojo-type="dijit/TitlePane" 
               data-dojo-props="title:'Switch Basemap',  closable:true,  open:false">

            <div data-dojo-type="dijit/layout/ContentPane" style="width:380px; height:200px; background-color:white;">
            <div id="basemapGallery" ></div></div>
          </div>
        </div>



<div id="results"> 

    <label id="result"></label>
    

 
</div>

</div>

               
</form>

     

</body>
</html>
