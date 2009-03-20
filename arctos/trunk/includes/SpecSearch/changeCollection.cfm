<script language="javascript" type="text/javascript">


function closeThis(){
	document.location=location.href;
	var theDiv = document.getElementById('customDiv');
	document.body.removeChild(theDiv);
}

function changeexclusive_collection_id (tgt) {
	DWREngine._execute(_cfscriptLocation, null, 'changeexclusive_collection_id',tgt, success_changeexclusive_collection_id);
}
function success_changeexclusive_collection_id (result) {
	if (result == 'success') {
		var e = document.getElementById('exclusive_collection_id').className='';
	} else {
		alert('An error occured: ' + result);
	}
}
</script>
<cfoutput>
<cfquery name="yourcollid" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	select collection_id,collection from collection
	order by collection
</cfquery>
<cfquery name="collid" datasource="uam_god">
	select cf_collection_id,collection from cf_collection
	order by collection
</cfquery>
<table class="ssrch">
	<tr>
		<td colspan="2" class="secHead">
				<span class="secLabel">Customize Identifiers</span>
				<span class="secControl" id="c_collevent"
					onclick="closeThis();">Close</span>
		</td>
	</tr>
	<tr>
		<td>
			<label for="yourColl">Your collection(s)</label>
			<select name="currColl" id="yourColl" size="6" readonly="readonly">
				<cfloop query="yourcollid">
					<option>#collection#</option>
				</cfloop>
			</select>
		</td>
		<td valign="top">
			<cfif len(session.roles) gt 0 and session.roles is "public">
			<label for="exclusive_collection_id">Set your collection(s)</label>
			<select name="exclusive_collection_id" id="exclusive_collection_id"
				onchange="this.className='red';changeexclusive_collection_id(this.value);" size="1">
			 	<option value=""></option>
			 	<option value="">All</option>
			  	<cfloop query="collid"> 
					<option value="#cf_collection_id#">#collection#</option>
			  	</cfloop> 
			</select>
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>