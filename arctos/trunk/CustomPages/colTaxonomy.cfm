<cfinclude template="/includes/_header.cfm">
<cfset title="COL taxonomy">
<script src="/includes/sorttable.js"></script>
<cfif not isdefined('sql')>
	<cfset sql="select * from ttaxonomy where rownum<10">
</cfif>
<script>
	function a(t){
		if(t=='badgenus'){
			t="select genus from ttaxonomy where nomenclatural_code not in ('ICBN','ICZN') and not regexp_like(genus,'^[A-Z][a-z]*$') group by genus";
		}
		if(t=='badsp'){
			t="select species from ttaxonomy where nomenclatural_code not in ('ICBN','ICZN') and not regexp_like(species,'^[a-z]*$') group by species";
		}
		if(t=='badssp'){
			t="select subspecies from ttaxonomy where nomenclatural_code not in ('ICBN','ICZN') and not regexp_like(subspecies,'^[a-z]*$') group by subspecies";
		}
		
		$('#sql').val(t)
	}
</script>
<cfoutput>
	<table>
		<tr>
			<td valign="top">
				<form name="f" method="get" action="colTaxonomy.cfm">
					<label for="sql">SQL</label>
					<textarea rows="4" cols="100" id="sql" name="sql">#sql#</textarea>
					<br><input type="submit">
					
					<br><input type="button" value="reset" onclick="document.location='colTaxonomy.cfm'">
				</form>
			</td>
			<td valign="top">
				<div class="likeLink" onclick="a('select * from ttaxonomy where fu is not null');">won't load</div>
				<div class="likeLink" onclick="a('select * from ttaxonomy where kingdom is null');">no kingdom</div>
				<div class="likeLink" onclick="a('badgenus');">funky genus (not ICBN/ICZN)</div>
				<div class="likeLink" onclick="a('badsp');">funky species (not ICBN/ICZN)</div>
				<div class="likeLink" onclick="a('badssp');">funky subspecies (not ICBN/ICZN)</div>
			</td>
		</tr>
	</table>
	<cfif sql does not contain " from ttaxonomy where ">
		badSQL<cfabort>
	</cfif>
	<cfquery name="d" datasource="uam_god">
		#preservesinglequotes(sql)#
	</cfquery>
	<div style="border:1px solid green">
		#sql#
	</div>
	n: #d.recordcount#
	<table border id="t" class="sortable">
		<tr>
			<cfloop list="#d.columnList#" index="i">
				<th>#i#</th>
			</cfloop>
		</tr>
		
	
		<cfloop query="d">
			<tr>
				<cfloop list="#d.columnList#" index="i">
					<td>#evaluate("d." & i)#</td>
				</cfloop>
			</tr>
		</cfloop>
	</table>
</cfoutput>






<cfinclude template="/includes/_footer.cfm">
