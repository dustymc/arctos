<cfinclude template="/includes/_header.cfm">
<style type="text/css"> html { height: 100% } body { height: 100%; margin: 0; padding: 0 } #map_canvas { height: 500px;width:600px; } </style>
<script src="http://maps.googleapis.com/maps/api/js?client=gme-museumofvertebrate1&sensor=false&libraries=drawing" type="text/javascript"></script> <script type="text/javascript">
	var map;
	var bounds;
	var rectangle;
	function initialize() {
		var mapOptions = {
			zoom: 8,
		    center: new google.maps.LatLng(44.490, -78.649),
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		};

		map = new google.maps.Map(document.getElementById('map_canvas'),mapOptions);




	}


function addARectangle(){

	bounds = new google.maps.LatLngBounds(
	   		new google.maps.LatLng(44.490, -78.649),
			new google.maps.LatLng(44.599, -78.443)
		);
		rectangle = new google.maps.Rectangle({
			bounds: bounds,
			editable: true,
			draggable: true
		});

		rectangle.setMap(map);

		google.maps.event.addListener(rectangle,'bounds_changed',sdas);
	}


	function sdas () {
		var NELat=rectangle.getBounds().getNorthEast().lat();
		var NELong=rectangle.getBounds().getNorthEast().lng();
		var SWLat=rectangle.getBounds().getSouthWest().lat();
		var SWLong=rectangle.getBounds().getSouthWest().lng();
		console.log(NELat + ' ' + NELong + ' ' +  SWLat   + ' ' + SWLong);
		}

	google.maps.event.addDomListener(window, 'load', initialize);






//google.maps.event.addListener(rectangle, 'bounds_changed', sdas);



</script>
<body>


	<span onclick="addARectangle()">addARectangle</span>
	<div id="map_canvas"></div>
</body>
<cfinclude template="/includes/_footer.cfm">
