<script type="text/javascript">
	jQuery(document).ready(function() {
		$("#begDate").datepicker();
		$("#endDate").datepicker();
		$("#inMon").multiselect();
	});

	function populateEvtAttrs(id) {
		var idNum=id.replace('event_attribute_type_','');
		var currentTypeValue=$("#event_attribute_type_" + idNum).val();
		var valueObjName="event_attribute_value_" + idNum;
		var unitObjName="event_attribute_units_" + idNum;
		var unitsCellName="event_attribute_units_cell_" + idNum;
		var valueCellName="event_attribute_value_cell_" + idNum;
		if (currentTypeValue.length==0){
			var s='<input  type="hidden" name="'+unitObjName+'" id="'+unitObjName+'" value="">';
			$("#"+unitsCellName).html(s);
			var s='<input  type="hidden" name="'+valueObjName+'" id="'+valueObjName+'" value="">';
			$("#"+valueCellName).html(s);
			return false;
		}
		var currentValue=$("#" + valueObjName).val();
		var currentUnits=$("#" + unitObjName).val();
		jQuery.getJSON("/component/DataEntry.cfc",
			{
				method : "getEvtAttCodeTbl",
				attribute : currentTypeValue,
				element : currentTypeValue,
				returnformat : "json",
				queryformat : 'column'
			},
			function (r) {
				if (r.STATUS != 'success'){
					alert('error occurred in getEvtAttCodeTbl');
					return false;
				} else {
					if (r.CTLFLD=='units'){
						var dv=$.parseJSON(r.DATA);
						var s='<select name="'+unitObjName+'" id="'+unitObjName+'">';
						s+='<option></option>';
						$.each(dv, function( index, value ) {
							s+='<option value="' + value[0] + '">' + value[0] + '</option>';
						});
						s+='</select>';
						$("#"+unitsCellName).html(s);
						$("#"+unitObjName).val(currentUnits);

						var s='<input  type="text" name="'+valueObjName+'" id="'+valueObjName+'"  placeholder="Default LIKE or =, <, >.">';
						$("#"+valueCellName).html(s);
						$("#"+valueObjName).val(currentValue);
					}
					if (r.CTLFLD=='values'){
						var dv=$.parseJSON(r.DATA);
						var s='<select name="'+valueObjName+'" id="'+valueObjName+'">';
						s+='<option></option>';
						$.each(dv, function( index, value ) {
							s+='<option value="' + value[0] + '">' + value[0] + '</option>';
						});
						s+='</select>';

						$("#"+valueCellName).html(s);
						$("#"+valueObjName).val(currentValue);

						var s='<input  type="hidden" name="'+unitObjName+'" id="'+unitObjName+'" value="">';
						$("#"+unitsCellName).html(s);
					}
					if (r.CTLFLD=='none'){
						var s='<input type="text" size="40"  name="'+valueObjName+'" id="'+valueObjName+'" placeholder="value">';
						$("#"+valueCellName).html(s);
						$("#"+valueObjName).val(currentValue);

						var s='<input  type="hidden" name="'+unitObjName+'" id="'+unitObjName+'" value="">';
						$("#"+unitsCellName).html(s);
					}
				}
			}
		);
	}

	function addEvtAttrSchTrm(){
		var i=parseInt($("#na").val());
		if (i>10){
			alert('Only 10 Event Attributes are currently supported; file an Issue.');
			return false;
		}
		var h='<tr>';
		h+='<td><select name="event_attribute_type_' + i + '" id="event_attribute_type_' + i + '" onchange="populateEvtAttrs(this.id)"></select></td>';
		h+='<td id="event_attribute_value_cell_' + i + '"><select name="event_attribute_value_' + i + '" id="event_attribute_value_' + i + '"></select></td>';
		h+='<td id="event_attribute_units_cell_' + i + '"><select name="event_attribute_units_' + i + '" id="event_attribute_units_' + i + '"></select></td>';
		h+='</tr>';
		$("#evtAttrSchTbl").append(h);
		$('#event_attribute_type_1').find('option').clone().appendTo('#event_attribute_type_' + i);
		populateEvtAttrs('event_attribute_type_' + i);
		$("#na").val(i + parseInt(1));
	}
</script>




<cfquery name="ctcollecting_source" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select collecting_source from ctcollecting_source order by collecting_source
</cfquery>
<cfquery name="ctverificationstatus"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select verificationstatus from ctverificationstatus group by verificationstatus order by verificationstatus
</cfquery>
<cfquery name="ctspecimen_event_type"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select specimen_event_type from ctspecimen_event_type group by specimen_event_type order by specimen_event_type
</cfquery>
<cfquery name="ctcoll_event_attr_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select event_attribute_type from ctcoll_event_attr_type order by event_attribute_type
</cfquery>

<cfoutput>
<table id="t_identifiers" class="ssrch">
	<tr>
		<td class="lbl">
			<span class="helpLink" id="year_collected">Collected On or After:</span>
		</td>
		<td class="srch">
			<table>
				<tr>
					<td>
						<label for="begYear">Year</label>
						<input type="number" min="1000" max="2500" step="1" name="begYear" id="begYear">
					</td>
					<td>
						<label for="begMon">Month</label>
						<select name="begMon" id="begMon" size="1">
							<option value=""></option>
							<option value="01">January</option>
							<option value="02">February</option>
							<option value="03">March</option>
							<option value="04">April</option>
							<option value="05">May</option>
							<option value="06">June</option>
							<option value="07">July</option>
							<option value="08">August</option>
							<option value="09">September</option>
							<option value="10">October</option>
							<option value="11">November</option>
							<option value="12">December</option>
						</select>
					</td>
					<td>
						<label for="begDay">Day</label>
						<select name="begDay" id="begDay" size="1">
							<option value=""></option>
							<cfloop from="1" to="31" index="day">
								<option value="#day#">#day#</option>
							</cfloop>
						</select>
					</td>
					<td valign="bottom"><span style="font-size:small;font-style:italic;font-weight:bold;">OR</span></td>
					<td>
						<label for="begDate">ISO8601 Date/Time</label>
						<input name="begDate" id="begDate" size="10" type="text">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="year_collected">Collected On or Before:</span>
		</td>
		<td class="srch">
			<table>
				<tr>
					<td>
						<label for="endYear">Year</label>
						<input type="number" min="1000" max="2500" step="1" name="endYear" id="endYear">
					</td>
					<td>
						<label for="endMon">Month</label>
						<select name="endMon" id="endMon" size="1">
							<option value=""></option>
							<option value="01">January</option>
							<option value="02">February</option>
							<option value="03">March</option>
							<option value="04">April</option>
							<option value="05">May</option>
							<option value="06">June</option>
							<option value="07">July</option>
							<option value="08">August</option>
							<option value="09">September</option>
							<option value="10">October</option>
							<option value="11">November</option>
							<option value="12">December</option>
						</select>
					</td>
					<td>
						<label for="endDay">Day</label>
						<select name="endDay" id="endDay" size="1">
							<option value=""></option>
							<cfloop from="1" to="31" index="day">
								<option value="#day#">#day#</option>
							</cfloop>
						</select>
					</td>
					<td valign="bottom"><span style="font-size:small;font-style:italic;font-weight:bold;">OR</span></td>
					<td>
						<label for="endDate">ISO8601 Date/Time</label>
						<input name="endDate" id="endDate" size="10" type="text">
					</td>
				</tr>
			</table>
			<span style="font-size:x-small;">(Leave blank to use Collected After values)</span>
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="month_in">Month:</span>
		</td>
		<td class="srch">
			<select name="inMon" id="inMon" size="4" multiple>
				<option value="'01'">January</option>
				<option value="'02'">February</option>
				<option value="'03'">March</option>
				<option value="'04'">April</option>
				<option value="'05'">May</option>
				<option value="'06'">June</option>
				<option value="'07'">July</option>
				<option value="'08'">August</option>
				<option value="'09'">September</option>
				<option value="'10'">October</option>
				<option value="'11'">November</option>
				<option value="'12'">December</option>
			</select>
		</td>
	</tr>
	<!---
	<tr>
		<td class="lbl">
			<span class="helpLink" id="incl_date">Strict Date Search?</span>
		</td>
		<td class="srch">
			<input type="checkbox" name="inclDateSearch" id="inclDateSearch" value="yes">
		</td>
	</tr>
	----->
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_verbatim_date">Verbatim Date:</span>
		</td>
		<td class="srch">
			<input type="text" name="verbatim_date" id="verbatim_date" size="50">
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_chronological_extent">Chronological Extent:</span>
			</a>
		</td>
		<td class="srch">
			<input type="text" name="chronological_extent" id="chronological_extent">
		</td>
	</tr>

	<tr>
		<td class="lbl">
			<span class="helpLink" id="_specimen_event_type">Record/Event Type:</span>
		</td>
		<td class="srch">
			<select name="specimen_event_type" id="specimen_event_type" size="1">
				<option value=""></option>
				<cfloop query="ctspecimen_event_type">
					<option value="#ctspecimen_event_type.specimen_event_type#">#ctspecimen_event_type.specimen_event_type#</option>
				</cfloop>
			</select>
		</td>
	</tr>

	<tr>
		<td class="lbl">
			<span class="helpLink" id="_specimen_event_remark">Record/Event Remark:</span>
		</td>
		<td class="srch">
			<input type="text" name="specimen_event_remark" id="specimen_event_remark" size="50">
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_collecting_source">Collecting Source:</span>
		</td>
		<td class="srch">
			<select name="collecting_source" id="collecting_source" size="1">
				<option value=""></option>
				<cfloop query="ctcollecting_source">
					<option value="#ctcollecting_source.collecting_source#">
						#ctcollecting_source.collecting_source#</option>
				</cfloop>
			</select>
		</td>
	</tr>

	<tr>
		<td class="lbl">
			<span class="helpLink" id="_collecting_method">Collecting Method:</span>
			</a>
		</td>
		<td class="srch">
			<input type="text" name="collecting_method" id="collecting_method" size="50">
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_verificationstatus">Verification Status:</span>
		</td>
		<td class="srch">
			<select name="verificationstatus" id="verificationstatus" size="1">
				<option value=""></option>
				<option value="!unaccepted">NOT unaccepted</option>
				<cfloop query="ctverificationstatus">
					<option value="#ctverificationstatus.verificationstatus#">#ctverificationstatus.verificationstatus#</option>
				</cfloop>
			</select>
			<span class="infoLink" onclick="getCtDoc('ctverificationstatus',SpecData.verificationstatus.value);">Define</span>

		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_verbatim_locality">Verbatim Locality:</span>
		</td>
		<td class="srch">
			<input type="text" name="verbatim_locality" id="verbatim_locality" size="50">
			<span class="infoLink" onclick="var e=document.getElementById('verbatim_locality');e.value='='+e.value;">Add = for exact match</span>
		</td>
	</tr>

	<tr>
		<td class="lbl">
			<span class="helpLink" id="_coll_event_remarks">Collecting Event Remark:</span>
		</td>
		<td class="srch">
			<input type="text" name="coll_event_remarks" id="coll_event_remarks" size="50">
		</td>
	</tr>
	<tr>
		<td class="lbl">
			<span class="helpLink" id="_event_attributes">
				Event Attributes
			</span>
			<br><span class="infoLink" onclick="addEvtAttrSchTrm()">Add a row</span>
		</td>
		<td >
			<table id="evtAttrSchTbl" border>
				<cfloop from="1" to="1" index="na">
					<tr class="">
						<td>
							<select name="event_attribute_type_#na#" id="event_attribute_type_#na#" onchange="populateEvtAttrs(this.id)">
								<option value="">select event attribute</option>
								<cfloop query="ctcoll_event_attr_type">
									<option value="#event_attribute_type#">#event_attribute_type#</option>
								</cfloop>
							</select>
						</td>
						<td id="event_attribute_value_cell_#na#">
							<input type="hidden" name="event_attribute_value_#na#" id="event_attribute_value_#na#">
						</td>
						<td id="event_attribute_units_cell_#na#">
							<input type="hidden" name="event_attribute_units_#na#" id="event_attribute_units_#na#">
						</td>
					</tr>
				</cfloop>
				<input type="hidden" name="na" id="na" value="#na#">
			</table>
		</td>
</tr>

</table>
</cfoutput>