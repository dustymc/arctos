<cfinclude template="/includes/_header.cfm">
<style type="text/css"> html { height: 100% } body { height: 100%; margin: 0; padding: 0 } #map_canvas { height: 500px;width:600px; } </style>
<script src="http://maps.googleapis.com/maps/api/js?client=gme-museumofvertebrate1&sensor=false&libraries=drawing" type="text/javascript"></script> <script type="text/javascript">
	var map;
	var bounds;
	var rectangle;
	function initialize() {
		var mapOptions = {
			zoom: 3,
		    center: new google.maps.LatLng(55, -135),
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		};

		map = new google.maps.Map(document.getElementById('map_canvas'),mapOptions);



	}


function addARectangle(){
	dieRectangleDie();
	$("#addARectangle").hide();
	$("#dieRectangleDie").show();

	var NELat=map.getBounds().getNorthEast().lat();
	var NELong=map.getBounds().getNorthEast().lng();
	var SWLat=map.getBounds().getSouthWest().lat();
	var SWLong=map.getBounds().getSouthWest().lng();

	// latitude is easy.....
	var latrange=NELat-SWLat;
	var nela=NELat-(latrange*.3);
	var swla=SWLat+(latrange*.3);

	// if longitudes are same sign....
	if ((NELong>0 && SWLong>0) || (NELong<0 && SWLong<0)){
		console.log('long same sign');
		var longrange=NELong-SWLong;
		var nelo=NELong-(longrange*.3);
		var swlo=SWLong+(longrange*.3);
	} else if (NELong<0 && SWLong>0) {
		console.log('NELong<0 && SWLong>0');
		var longrange=NELong+SWLong;
		var nelo=NELong-(longrange*.3);
		var swlo=SWLong+(longrange*.3);
	} else {
		console.log('this should never happen - aborting.....');
		return false;
	}

	/*
	var longrange=NELong-SWLong;



	if (NELong>0){

		var longrange=NELong-SWLong;
		var nelo=NELong+(longrange*.4);
	} else {

		var longrange=SWLong-NELong;
		var nelo=NELong-(longrange*.4);
	}

	if (SWLong>0){
		var swlo=SWLong+(longrange*.4);
	} else {
		var swlo=SWLong-(longrange*.4);
	}

*/

	console.log(NELat + ' ' + NELong + ' ' +  SWLat   + ' ' + SWLong);

	console.log('longrange='+longrange);

	console.log('nelo='+nelo);

	console.log('swlo='+swlo);

	console.log('NELat='+NELat);
	bounds = new google.maps.LatLngBounds(
	   		new google.maps.LatLng(nela, swlo ),
			new google.maps.LatLng(swla, nelo)
		);
		rectangle = new google.maps.Rectangle({
			bounds: bounds,
			editable: true,
			draggable: true
		});

		rectangle.setMap(map);
		whereIsTheRectangle();


		google.maps.event.addListener(rectangle,'bounds_changed',whereIsTheRectangle);


	}

function dieRectangleDie(){
	$("#addARectangle").show();
	$("#dieRectangleDie").hide();
	try {
		rectangle.setMap();
	} catch(e){}

}

	function whereIsTheRectangle () {
		var NELat=rectangle.getBounds().getNorthEast().lat();
		var NELong=rectangle.getBounds().getNorthEast().lng();
		var SWLat=rectangle.getBounds().getSouthWest().lat();
		var SWLong=rectangle.getBounds().getSouthWest().lng();
		console.log(NELat + ' ' + NELong + ' ' +  SWLat   + ' ' + SWLong);
		$("#NELat").val(NELat);
		$("#NELong").val(NELong);
		$("#SWLat").val(SWLat);
		$("#SWLong").val(SWLong);

	}

	google.maps.event.addDomListener(window, 'load', initialize);






//google.maps.event.addListener(rectangle, 'bounds_changed', sdas);



</script>
<body>


	<span id="addARectangle" onclick="addARectangle()">addARectangle</span>
	<span id="dieRectangleDie" style="display: none;" onclick="dieRectangleDie()">dieRectangleDie</span>
	<div id="map_canvas"></div>

	<form method="get" action="/SpecimenResults.cfm" target="_blank">
	NELat<input type="text" name="NELat" size="6" id="NELat">
	NELong<input type="text" name="NELong" size="6" id="NELong">
	SWLat<input type="text" name="SWLat" size="6" id="SWLat">
	SWLong<input type="text" name="SWLong" size="6" id="SWLong">
		<input type="submit">
	</form>
</body>
<cfinclude template="/includes/_footer.cfm">
