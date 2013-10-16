<style>
	#mapTax{
		width:40%;
		float:right;
	}
</style>
<cfoutput>
	<cfset internalPath="#Application.webDirectory#/cache/">
	<cfset externalPath="#Application.ServerRootUrl#/cache/">
	<cfif not isdefined("method")>
		<cfset method="">
	</cfif>
	<cfif method is "exact">
		<cfset fn="_#replace(scientific_name,' ','-','all')#.csv">
	<cfelse>
		<cfset fn="#replace(scientific_name,' ','-','all')#.csv">
	</cfif>
	<cfif not fileexists("#internalPath##fn#")>
		building cache.....
		<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		 	select 
		 		count(*) c,
		 		locality_id,
		 		scientific_name, 
		 		dec_lat,
		 		dec_long,
		 		datum,
		 		coordinateuncertaintyinmeters
		 	from filtered_flat
		 	where 
				dec_lat is not null and 
		 		dec_long is not null and
		 		<cfif method is "exact">
					scientific_name = '#scientific_name#'
				<cfelse>
					scientific_name like '#scientific_name#%'
				</cfif>
		 	group by
		 		locality_id,
		 	 	scientific_name, 
		 		dec_lat,
		 		dec_long,
		 		datum,
		 		coordinateuncertaintyinmeters
		</cfquery>
		<cfdump var=#d#>
		<cfif d.recordcount is 0>
			<cfabort>
		</cfif>
		<cfset variables.encoding="UTF-8">
		<cfset variables.fileName=internalPath & fn>
		<cfscript>
			variables.joFileWriter = createObject('Component', '/component.FileWriter').init(variables.fileName, variables.encoding, 32768);
			x='"c","locality_id","scientific_name","dec_lat","dec_long","datum","coordinateuncertaintyinmeters"';
			variables.joFileWriter.writeLine(x);      
		</cfscript>
		<cfloop query="d">
			<cfscript>
				x='"#c#","#locality_id#","#scientific_name#","#dec_lat#","#dec_long#","#datum#","#coordinateuncertaintyinmeters#"';				
				variables.joFileWriter.writeLine(kml);
			</cfscript>
		</cfloop>
		<cfscript>
			variables.joFileWriter.close();
		</cfscript>
	</cfif>
	<br>found a file - now reading it into a query.....
	
	<cffile action="READ" file="#internalPath#/#fn#" variable="fileContent">

	<cfdump var=#fileContent#>
	
	<cfabort>
	
	
	

	<cfset fileContent=replace(fileContent,"'","''","all")>

	 <cfset arrResult = CSVToArray(CSV = fileContent.Trim()) />

 <cfquery name="die" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	delete from cf_temp_cont_edit
</cfquery>

<cfset colNames="">
	<cfloop from="1" to ="#ArrayLen(arrResult)#" index="o">
		<cfset colVals="">
			<cfloop from="1"  to ="#ArrayLen(arrResult[o])#" index="i">
				<cfset thisBit=arrResult[o][i]>
				<cfif #o# is 1>
					<cfset colNames="#colNames#,#thisBit#">
				<cfelse>
					<cfset colVals="#colVals#,'#thisBit#'">
				</cfif>
			</cfloop>
		<cfif #o# is 1>
			<cfset colNames=replace(colNames,",","","first")>
		</cfif>	
		<cfif len(#colVals#) gt 1>
			<cfset colVals=replace(colVals,",","","first")>
			<cfquery name="ins" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				insert into cf_temp_cont_edit (#colNames#) values (#preservesinglequotes(colVals)#)
			</cfquery>
		</cfif>
	</cfloop>





	
	<span style="font-size:smaller;color:red;">Encumbered records are excluded.</span>
	<div id="taxarangemap" style="width: 100%;; height: 400px;"></div>
	<script language="javascript" type="text/javascript">
		jQuery(document).ready(function() {
	 		var map;
			var myLatLng = new google.maps.LatLng(49.496675, -102.65625);
			var mapOptions = {
			  zoom: 4,
			  center: myLatLng,
			  mapTypeId: google.maps.MapTypeId.ROADMAP
			}		
        	map = new google.maps.Map(document.getElementById("taxarangemap"), mapOptions);
			var georssLayer = new google.maps.KmlLayer('#externalPath##fn#');
			georssLayer.setMap(map);
		});
	</script>
	<span id="toggleExactmatch">
		<cfif method is "exact">
			Showing exact matches - <span class="likeLink" onclick="reloadThis('')"> show matches for '#scientific_name#%'</span>
		<cfelse>
			Showing fuzzy matches - <span class="likeLink" onclick="reloadThis('exact')"> show matches for exactly '#scientific_name#'</span>
		</cfif>
	</span>
</cfoutput>