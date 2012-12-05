<cfinclude template="/includes/_header.cfm">
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>

	<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/themes/base/jquery-ui.css" type="text/css" />


<!----
 <script src="http://code.jquery.com/jquery-1.8.3.js"></script>

this is default and it works

  #sortable { list-style-type: none; margin: 0; padding: 0; width: 450px; }
    #sortable li { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 200px; height: 90px; font-size: 4em; text-align: center; }
	#sortable li.dubbl { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 400px; height: 90px; font-size: 4em; text-align: center; }
---->
    <style>
    #sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
    #sortable li { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 45%;}
	#sortable li.dubbl { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 90%;}
    </style>
    <script>
    $(function() {
        $( "#sortable" ).sortable();
        $( "#sortable" ).disableSelection();
    });
    </script>
<cfoutput>

<ul id="sortable">
    <li class="ui-state-default">

	<table cellpadding="0" cellspacing="0" class="fs">
								<tr>
									<td>
										<img src="/images/info.gif" border="0" onClick="getDocs('geology_attributes')" class="likeLink" alt="[ help ]">
										<table cellpadding="0" cellspacing="0">
											<tr>
												<th nowrap="nowrap"><span class="f11a">Geol Att.</span></th>
												<th><span class="f11a">Geol Att. Value</span></th>
												<th><span class="f11a">Determiner</span></th>
												<th><span class="f11a">Date</span></th>
												<th><span class="f11a">Method</span></th>
												<th><span class="f11a">Remark</span></th>
											</tr>
											<cfloop from="1" to="6" index="i">
												<div id="#i#">
												<tr id="d_geology_attribute_#i#">
													<td>
														<select name="geology_attribute_#i#" id="geology_attribute_#i#" size="1" onchange="populateGeology(this.id);">
															<option value=""></option>

														</select>
													</td>
													<td>
														<select name="geo_att_value_#i#" id="geo_att_value_#i#">
														</select>
													</td>
													<td>
														<input type="text"
															name="geo_att_determiner_#i#"
															id="geo_att_determiner_#i#"
															onchange="getAgent('nothing',this.id,'dataEntry',this.value);"
															onkeypress="return noenter(event);">
													</td>
													<td>
														<input type="text"
															name="geo_att_determined_date_#i#"
															id="geo_att_determined_date_#i#"
															size="10">
													</td>
													<td>
														<input type="text"
															name="geo_att_determined_method_#i#"
															id="geo_att_determined_method_#i#"
															size="15">
													</td>
													<td>
														<input type="text"
															name="geo_att_remark_#i#"
															id="geo_att_remark_#i#"
															size="15">
													</td>
												</tr>
												</div>
											</cfloop>
										</table>
									</td>
								</tr>
							</table>
	</li>
    <li class="ui-state-default">2</li>
    <li class="ui-state-default">3</li>
    <li class="ui-state-default">4</li>
    <li class="ui-state-default">5</li>
    <li class="ui-state-default">6</li>
    <li class="ui-state-default">7</li>
    <li class="ui-state-default">8</li>
    <li class="ui-state-default">9</li>
    <li class="ui-state-default">10</li>
    <li class="ui-state-default">11</li>
    <li class="ui-state-default dubbl">

	<table border>
						<tr>
							<td rowspan="99" valign="top">
								<img src="/images/info.gif" border="0" onClick="getDocs('parts')" class="likeLink" alt="[ help ]">
							</td>
							<th><span class="f11a">Part Name</span></th>
							<th><span class="f11a">Condition</span></th>
							<th><span class="f11a">Disposition</span></th>
							<th><span class="f11a">##</span></th>
							<th><span class="f11a">Barcode</span></th>
							<th><span class="f11a">Label</span></th>
							<th><span class="f11a">Remark</span></th>
						</tr>
						<cfloop from="1" to="12" index="i">
							<tr id="d_part_name_#i#">
								<td>
									<input type="text" name="part_name_#i#" id="part_name_#i#"
										 size="25"
										onchange="DEpartLookup(this.id);requirePartAtts('#i#',this.value);"
										onkeypress="return noenter(event);">
								</td>
								<td>
									<input type="text" name="part_condition_#i#" id="part_condition_#i#">
								</td>
								<td>
									<select id="part_disposition_#i#" name="part_disposition_#i#">
										<option value=""></option>

									</select>
								</td>
								<td>
									<input type="text" name="part_lot_count_#i#" id="part_lot_count_#i#" size="1">
								</td>
								<td>
									<input type="text" name="part_barcode_#i#" id="part_barcode_#i#"
										 size="15" onchange="setPartLabel(this.id);">
								</td>
								<td>
									<input type="text" name="part_container_label_#i#" id="part_container_label_#i#" size="10">
								</td>
								<td>
									<input type="text" name="part_remark_#i#" id="part_remark_#i#" size="40">
								</td>
							</tr>
						</cfloop>
					</table>

	</li>
</ul>

	</cfoutput>