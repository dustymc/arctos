<cfinclude template="/includes/_header.cfm">
	<link href="/includes/jQRangeSlider-5.7.2/css/iThing.css" rel="stylesheet" media="screen">
  <script src="/includes/jQRangeSlider-5.7.2/jQDateRangeSlider-min.js"></script>

<hr>---------- date range slider demo ----------<hr>
<style>
	#dateSlider{width:40%;}
</style>
<script>
$(document).ready(function(){
      $("#dateSlider").dateRangeSlider({
        bounds: {min: new Date(1800, 0, 1), max: new Date()},
        defaultValues: {min: new Date(1800, 1, 10), max: new Date()},
        scales: [{
          next: function(val){
            var next = new Date(val);
            return new Date(next.setMonth(next.getMonth() + 1));
          },
          label: function(val){
            return Months[val.getMonth()];
          },
           formatter:function(val){
                var days =  ("0" + (val.getDate()).slice(-2)),
                  month = val.getMonth() + 1,
                  year = val.getFullYear();
                return days + "/" + month + "/" + year;
              }

        }]
      });

          $("#dateSlider").bind("valuesChanged", function(e, data){
          	console.log(data);
          	var bd=("0" + (data.values.min.getDate())).slice(-2) ,
          		bm=("0" + (data.values.min.getMonth() + 1)).slice(-2),
          		by=data.values.min.getFullYear();
          	var ed=("0" + (data.values.max.getDate())).slice(-2) ,
          		em=("0" + (data.values.max.getMonth() + 1)).slice(-2),
          		ey=data.values.max.getFullYear();

          	$("#minDate").val(by + '-' + bm + '-' + bd );
          	$("#maxDate").val(ey + '-' + em + '-' + ed );

          	console.log('by: ' + by);
          	console.log('bm: ' + bm);
          	console.log('bd: ' + bd);
      console.log("Values just changed. min: " + data.values.min + " max: " + data.values.max);



    });

$("#sss").submit(function( event ) {
	$.ajax({
		url: "/component/simplesearch.cfc?queryformat=column&method=getSSSpecimens&returnformat=json",
		type: "GET",
		dataType: "json",
		data:  {
			what:  $("#what").val,
			when:  $("#when").val,
			where:  $("#where").val,
		},
		success: function(r) {
			alert(r);

		},
		error: function (xhr, textStatus, errorThrown){
		    alert(errorThrown + ': ' + textStatus + ': ' + xhr);
		}
	});



  event.preventDefault();
});

    });
</script>
<!----

        $("#formatterExample").dateRangeSlider({
          formatter:function(val){
                var days = val.getDate(),
                  month = val.getMonth() + 1,
                  year = val.getFullYear();
                return days + "/" + month + "/" + year;
              }
        });

		---->











<hr>---------- possible "simple search" or default Arctos search page demo ----------<hr>

<h1>Search Arctos</h1>
<h2>Site Search</h2>

<div id="cse" style="width: 50%;">Loading</div>

<script src="http://www.google.com/jsapi" type="text/javascript"></script>
<script type="text/javascript">
  google.load('search', '1', {language : 'en'});
  google.setOnLoadCallback(function(){
    var customSearchControl = new google.search.CustomSearchControl('011384802149075345004:_xhrdehjm50');
    customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    customSearchControl.draw('cse');
  }, true);
</script>
<link rel="stylesheet" href="http://www.google.com/cse/style/look/default.css" type="text/css" />




<h2>Specimens</h2>
<p>
<a href="/SpecimenSearch.cfm">Click here for advanced specimen search</a>
</p>

<blockquote>
	<form name="sss" id="sss">
<label for="">What</label>
<input type="text" id="what" placeholder="identification or common name">
<br>Try <a href="#">Marmot</a> or <a href="#">Arrowhead</a>

<label for="">Where</label>
<input id="where" type="text" placeholder="Place Name">
<br>Try <a href="#">Albuquerque</a>


<label for="">When</label>
	     <div id="dateSlider"></div>


From <input id="minDate" placeholder="earliest date"> to <input id="maxDate" placeholder="latest date">

<br><input type="submit" value="find specimens">
</form>
</blockquote>

<H2>
	Projects and Publications
</H2>

	<br>there's a box or 2 here....

<H2>
	Taxonomy
</H2>

	<br>there's a box or 2 here....


<H2>
	People and Agencies
</H2>

	<br>there's a box or 2 here....

<cfinclude template="/includes/_pickFooter.cfm">