function saveSearch(returnURL){
	var sName=prompt("Name this search", "my search");
	if (sName!==null){
		var sn=encodeURIComponent(sName);
		var ru=encodeURI(returnURL);
		jQuery.getJSON("/component/functions.cfc",
			{
				method : "saveSearch",
				returnURL : ru,
				srchName : sn,
				returnformat : "json",
				queryformat : 'column'
			},
			function (r) {
				if(r!='success'){
					alert(r);
				}
			}
		);
	}
}
function insertTypes(idList) {
	var s=document.createElement('DIV');
	s.id='ajaxStatus';
	s.className='ajaxStatus';
	s.innerHTML='Checking for Types...';
	document.body.appendChild(s);
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "getTypes",
			idList : idList,
			returnformat : "json",
			queryformat : 'column'
		},
		function (result) {
			var sBox=document.getElementById('ajaxStatus');
			try{
				sBox.innerHTML='Processing Types....';
				for (i=0; i<result.ROWCOUNT; ++i) {
					var sid=result.DATA.collection_object_id[i];
					var tl=result.DATA.typeList[i];
					var sel='CatItem_' + sid;
					if (sel.length>0){
						var el=document.getElementById(sel);
						var ns='<div class="showType">' + tl + '</div>';
						el.innerHTML+=ns;
					}
				}
			}
			catch(e){}
			document.body.removeChild(sBox);
		}
	);
}
function insertMedia(idList) {
	var s=document.createElement('DIV');
	s.id='ajaxStatus';
	s.className='ajaxStatus';
	s.innerHTML='Checking for Media...';
	document.body.appendChild(s);
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "getMedia",
			idList : idList,
			returnformat : "json",
			queryformat : 'column'
		},
		function (result) {
			try{
				var sBox=document.getElementById('ajaxStatus');
				sBox.innerHTML='Processing Media....';
				for (i=0; i<result.ROWCOUNT; ++i) {
					var sel;
					var sid=result.DATA.collection_object_id[i];
					var mid=result.DATA.media_id[i];
					var rel=result.DATA.media_relationship[i];
					if (rel=='cataloged_item') {
						sel='CatItem_' + sid;
					} else if (rel=='collecting_event') {
						sel='SpecLocality_' + sid;
					}
					if (sel.length>0){
						var el=document.getElementById(sel);
						var ns='<a href="/MediaSearch.cfm?action=search&media_id='+mid+'" class="mediaLink" target="_blank" id="mediaSpan_'+sid+'">';
						ns+='Media';
						ns+='</a>';
						el.innerHTML+=ns;
					}
				}
				document.body.removeChild(sBox);
				}
			catch(e) {
				sBox=document.getElementById('ajaxStatus');
				document.body.removeChild(sBox);
			}
		}
	);
}
function addPartToLoan(partID) {
	var rs = "item_remark_" + partID;
	var is = "item_instructions_" + partID;
	var ss = "subsample_" + partID;
	var remark=document.getElementById(rs).value;
	var instructions=document.getElementById(is).value;
	var subsample=document.getElementById(ss).checked;
	if (subsample==true) {
		subsample=1;
	} else {
		subsample=0;
	}
	var transaction_id=document.getElementById('transaction_id').value;
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "addPartToLoan",
			transaction_id : transaction_id,
			partID : partID,
			remark : remark,
			instructions : instructions,
			subsample : subsample,
			returnformat : "json",
			queryformat : 'column'
		},
		function (result) {
			var rar = result.split("|");
			var status=rar[0];
			if (status==1){
				var b = "theButton_" + rar[1];
				var theBtn = document.getElementById(b);
				theBtn.value="In Loan";
				theBtn.onclick="";	
			}else{
				var msg = rar[1];
				alert('An error occured!\n' + msg);
			}
		}
	);
}
function success_makePartThingy(r){
	result=r.DATA;
	var lastID;
	var theTable;
	for (i=0; i<r.ROWCOUNT; ++i) {
		var cid = 'partCell_' + result.COLLECTION_OBJECT_ID[i];
		if (document.getElementById(cid)){
			var theCell = document.getElementById(cid);
			theCell.innerHTML='Fetching loan data....';
			if (lastID == result.COLLECTION_OBJECT_ID[i]) {
				theTable += "<tr>";
			} else {
				theTable = '<table border width="100%"><tr>';
			}
			theTable += '<td nowrap="nowrap" class="specResultPartCell">';
			theTable += '<i>' + result.PART_NAME[i];
			if (result.SAMPLED_FROM_OBJ_ID[i] > 0) {
				theTable += '&nbsp;sample';
			}
			theTable += "&nbsp;(" + result.COLL_OBJ_DISPOSITION[i] + ")</i> [" + result.BARCODE[i] + "]";
			theTable += '</td><td nowrap="nowrap" class="specResultPartCell">';
			theTable += 'Remark:&nbsp;<input type="text" name="item_remark" size="10" id="item_remark_' + result.PARTID[i] + '">';
			theTable += '</td><td nowrap="nowrap" class="specResultPartCell">';
			theTable += 'Instr.:&nbsp;<input type="text" name="item_instructions" size="10" id="item_instructions_' + result.PARTID[i] + '">';
			theTable += '</td><td nowrap="nowrap" class="specResultPartCell">';
			theTable += 'Subsample?:&nbsp;<input type="checkbox" name="subsample" id="subsample_' + result.PARTID[i] + '">';
			theTable += '</td><td nowrap="nowrap" class="specResultPartCell">';
			theTable += '<input type="button" id="theButton_' + result.PARTID[i] + '"';
			theTable += ' class="insBtn"';
			if (result.TRANSACTION_ID[i] > 0) {
				theTable += ' onclick="" value="In Loan">';
			} else {
				theTable += ' value="Add" onclick="addPartToLoan(';
				theTable += result.PARTID[i] + ');">';
			}
			if (result.ENCUMBRANCE_ACTION[i]!==null) {
				theTable += '<br><i>Encumbrances:&nbsp;' + result.ENCUMBRANCE_ACTION[i] + '</i>';
			}
			theTable +="</td>";
			if (result.COLLECTION_OBJECT_ID[i+1] && result.COLLECTION_OBJECT_ID[i+1] == result.COLLECTION_OBJECT_ID[i]) {
				theTable += "</tr>";
			} else {
				theTable += "</tr></table>";
				theCell.innerHTML = theTable;
			}
			lastID = result.COLLECTION_OBJECT_ID[i];
		}
	}
}
function makePartThingy() {
	var transaction_id = document.getElementById("transaction_id").value;
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "getLoanPartResults",
			transaction_id : transaction_id,
			returnformat : "json",
			queryformat : 'column'
		},
		success_makePartThingy
	);	
}
function cordFormat(str) {
	var rStr;
	if (str==null) {
		rStr='';
	} else {
		rStr = str;
		var rExp = /s/gi;
		rStr = rStr.replace(rExp,"\'\'");
		rExp = /d/gi;
		rStr = rStr.replace(rExp,'<sup>o</sup>');
		rExp = /m/gi;
		rStr = rStr.replace(rExp,"\'");
		rExp = / /gi;
		rStr = rStr.replace(rExp,'&nbsp;');
	}
	return rStr;
}
function spaceStripper(str) {
	str=String(str);
	var rStr;
	if (str==null) {
		rStr='';
	} else {
		rStr = str.replace(/ /gi,'&nbsp;');
	}
	return rStr;
}
function splitByComma(str) {
	var rStr;
	if (str==null) {
		rStr='';
	} else {
		var rExp = /, /gi;
		rStr = str.replace(rExp,'<br>');
		rExp = / /gi;
		rStr = rStr.replace(rExp,'&nbsp;');
	}
	return rStr;
}
function splitByLF(str) {
	var rStr;
	if (str==null) {
		rStr='';
	} else {
		rStr = str.replace('\n','<br>','g');
	}
	return rStr;
}
function splitBySemicolon(str) {
	var rStr;
	if (str==null) {
		rStr='';
	} else {
		var rExp = /; /gi;
		rStr = str.replace(rExp,'<br>');
		rExp = / /gi;
		rStr = rStr.replace(rExp,'&nbsp;');
	}
	return rStr;
}
function goPickParts (collection_object_id,transaction_id) {
	var url='/picks/internalAddLoanItemTwo.cfm?collection_object_id=' + collection_object_id +"&transaction_id=" + transaction_id;
	mywin=windowOpener(url,'myWin','height=300,width=800,resizable,location,menubar ,scrollbars ,status ,titlebar,toolbar');
}
function removeItems() {
	var theList = document.getElementById('killRowList').value;
	var currentLocn = document.getElementById('mapURL').value;
	document.location='SpecimenResults.cfm?' + currentLocn + '&exclCollObjId=' + theList;
}
function toggleKillrow(id,status) {
	//alert(id + ' ' + status);

	var theEl = document.getElementById('killRowList');
	if (status==true) {
		var theArray = [];
		if (theEl.value.length > 0) {
			theArray = theEl.value.split(',');
		}
		theArray.push(id);
		var theString = theArray.join(",");
		theEl.value = theString;
	} else {
		var theArray = theEl.value.split(',');
		for (i=0; i<theArray.length; ++i) {
			//alert(theArray[i]);
			if (theArray[i] == id) {
				theArray.splice(i,1);
			}
		}
		var theString = theArray.toString();
		theEl.value=theString;
	}
	var theButton = document.getElementById('removeChecked');
	if (theString.length > -1) {
		theButton.style.display='block';
	} else {
		theButton.style.display='none';
	}
}

function getSpecResultsData (startrow,numrecs,orderBy,orderOrder) {
	if (document.getElementById('resultsGoHere')) {
		var guts = '<div id="loading" style="position:relative;top:0px;left:0px;z-index:999;color:white;background-color:green;';
	 	guts += 'font-size:large;font-weight:bold;padding:15px;">Fetching data...</div>';
	 	var tgt = document.getElementById('resultsGoHere');
		tgt.innerHTML = guts;
	}
	if (isNaN(startrow) && startrow.indexOf(',') > 0) {
   		var ar = startrow.split(',');
   		startrow = ar[0];
   		numrecs = ar[1];
   	}
	if (orderBy==null) {
		if (document.getElementById('orderBy1') && document.getElementById('orderBy1')) {
			var o1=document.getElementById('orderBy1').value; 
			var o2=document.getElementById('orderBy2').value;
			var orderBy = o1 + ',' + o2;
		} else {
			var orderBy = 'cat_num';
		}		
	}
	if (orderOrder==null) {
		var orderOrder = 'ASC';
	}
	if (orderBy.indexOf(',') > -1) {
		var oA=orderBy.split(',');
		if (oA[1]==oA[0]){
			orderBy=oA[0] + ' ' + orderOrder;
		} else {
			orderBy=oA[0] + ' ' + orderOrder + ',' + oA[1] + ' ' + orderOrder;
		}
	} else {
		orderBy += ' ' + orderOrder;
	}
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "getSpecResultsData",
			startrow : startrow,
			numrecs : numrecs,
			orderBy : orderBy,
			returnformat : "json",
			queryformat : 'column'
		},
		success_getSpecResultsData
	);
}
function success_getSpecResultsData(result){
	var data = result.DATA;
	var attributes="SNV_results,abundance,age,age_class,appraised_value,axillary_girth,body_condition,body_width,breadth,bursa,carapace_length,caste,clutch_size,clutch_size_nest_parasite,colors,crown_rump_length,curvilinear_length,diploid_number,ear_from_crown,ear_from_notch,egg_content_weight,eggshell_thickness,fat_deposition,forearm_length,gonad,head_length,head_width,height,hind_foot_with_claw,hind_foot_without_claw,image_confirmed,incubation_stage,molt_condition,neck_width,nest_description,number_of_labels,numeric_age,ovum,reproductive_condition,reproductive_data,skull_ossification,snout_vent_length,soft_part_colors,soft_parts,stomach_contents,tail_base_width,tail_condition,tail_length,title,total_length,tragus_length,trap_identifier,trap_type,unformatted_measurements,verbatim_host_ID,verbatim_preservation_date,weight,width,wing_span";
	var attAry=attributes.split(",");
	var nAtt=attAry.length;
	var collection_object_id = data.COLLECTION_OBJECT_ID[0];
	if (collection_object_id < 1) {
		var msg = data.message[0];
		alert(msg);
	} else {
		var clist = data.COLUMNLIST[0];
		var tgt = document.getElementById('resultsGoHere');
		if (document.getElementById('killrow') && document.getElementById('killrow').value==1){
			var killrow = 1;
		} else {
			var killrow = 0;
		}
		if (document.getElementById('action') && document.getElementById('action').value.length>0){
			var action = document.getElementById('action').value;
		} else {
			var action='';
		}
		if (document.getElementById('transaction_id') && document.getElementById('transaction_id').value.length>0){
			var transaction_id = document.getElementById('transaction_id').value;
		} else {
			var transaction_id='';
		}
		if (document.getElementById('loan_request_coll_id') && document.getElementById('loan_request_coll_id').value.length>0){
			var loan_request_coll_id = document.getElementById('loan_request_coll_id').value;
		} else {
			var loan_request_coll_id='';
		}
		if (document.getElementById('mapURL') && document.getElementById('mapURL').value.length>0){
			var mapURL = document.getElementById('mapURL').value;
		} else {
			var mapURL='';
		}
		var theInnerHtml = '<table class="specResultTab"><tr>';
			if (killrow == 1){
				theInnerHtml += '<th>Remove</th>';
			}
			theInnerHtml += '<th>Cat&nbsp;Num</th>';
			if (loan_request_coll_id.length > 0){
				theInnerHtml +='<th>Request</th>';
			}
			if (action == 'dispCollObj'){
				theInnerHtml +='<th>Loan</th>';
			}
			if (data.COLUMNLIST[0].indexOf('CUSTOMID')> -1) {
				theInnerHtml += '<th>';
					theInnerHtml += data.MYCUSTOMIDTYPE[0];
				theInnerHtml += '</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MEDIA')> -1) {
				theInnerHtml += '<th>Media</th>';
			}
			theInnerHtml += '<th>Identification</th>';
			if (data.COLUMNLIST[0].indexOf('ID_SENSU')> -1) {
				theInnerHtml += '<th>ID sensu</th>';
			}
			if (data.COLUMNLIST[0].indexOf('SCI_NAME_WITH_AUTH')> -1) {
				theInnerHtml += '<th>Scientific&nbsp;Name</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ID_HISTORY')> -1) {
				theInnerHtml += '<th>Identification&nbsp;History</th>';
			}
			if (data.COLUMNLIST[0].indexOf('CITATIONS')> -1) {
				theInnerHtml += '<th>Citations</th>';
			}
			if (data.COLUMNLIST[0].indexOf('IDENTIFIED_BY')> -1) {
				theInnerHtml += '<th>Identified&nbsp;By</th>';
			}
			if (data.COLUMNLIST[0].indexOf('PHYLORDER')> -1) {
				theInnerHtml += '<th>Order</th>';
			}
			if (data.COLUMNLIST[0].indexOf('FAMILY')> -1) {
				theInnerHtml += '<th>Family</th>';
			}
			if (data.COLUMNLIST[0].indexOf('OTHERCATALOGNUMBERS')> -1) {
				theInnerHtml += '<th>Other&nbsp;Identifiers</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ACCESSION')> -1) {
				theInnerHtml += '<th>Accession</th>';
			}
			if (data.COLUMNLIST[0].indexOf('COLLECTORS')> -1) {
				theInnerHtml += '<th>Collectors</th>';
			}
			if (data.COLUMNLIST[0].indexOf('PREPARATORS')> -1) {
				theInnerHtml += '<th>Preparators</th>';
			}
			if (data.COLUMNLIST[0].indexOf('VERBATIMLATITUDE')> -1) {
				theInnerHtml += '<th>Latitude</th>';
			}
			if (data.COLUMNLIST[0].indexOf('VERBATIMLONGITUDE')> -1) {
				theInnerHtml += '<th>Longitude</th>';
			}
			if (data.COLUMNLIST[0].indexOf('COORDINATEUNCERTAINTYINMETERS')> -1) {
				theInnerHtml += '<th>Max&nbsp;Error&nbsp;(m)</th>';
			}
			if (data.COLUMNLIST[0].indexOf('DATUM')> -1) {
				theInnerHtml += '<th>Datum</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ORIG_LAT_LONG_UNITS')> -1) {
				theInnerHtml += '<th>Original&nbsp;Lat/Long&nbsp;Units</th>';
			}
			if (data.COLUMNLIST[0].indexOf('LAT_LONG_DETERMINER')> -1) {
				theInnerHtml += '<th>Georeferenced&nbsp;By</th>';
			}
			if (data.COLUMNLIST[0].indexOf('LAT_LONG_REF_SOURCE')> -1) {
				theInnerHtml += '<th>Lat/Long&nbsp;Reference</th>';
			}
			if (data.COLUMNLIST[0].indexOf('LAT_LONG_REMARKS')> -1) {
				theInnerHtml += '<th>Lat/Long&nbsp;Remarks</th>';
			}
			if (data.COLUMNLIST[0].indexOf('CONTINENT_OCEAN')> -1) {
				theInnerHtml += '<th>Continent</th>';
			}
			if (data.COLUMNLIST[0].indexOf('COUNTRY')> -1) {
				theInnerHtml += '<th>Country</th>';
			}
			if (data.COLUMNLIST[0].indexOf('STATE_PROV')> -1) {
				theInnerHtml += '<th>State</th>';
			}
			if (data.COLUMNLIST[0].indexOf('SEA')> -1) {
				theInnerHtml += '<th>Sea</th>';
			}
			if (data.COLUMNLIST[0].indexOf('QUAD')> -1) {
				theInnerHtml += '<th>Map&nbsp;Name</th>';
			}
			if (data.COLUMNLIST[0].indexOf('FEATURE')> -1) {
				theInnerHtml += '<th>Feature</th>';
			}
			if (data.COLUMNLIST[0].indexOf('COUNTY')> -1) {
				theInnerHtml += '<th>County</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ISLAND_GROUP')> -1) {
				theInnerHtml += '<th>Island&nbsp;Group</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ISLAND')> -1) {
				theInnerHtml += '<th>Island</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ASSOCIATED_SPECIES')> -1) {
				theInnerHtml += '<th>Associated&nbsp;Species</th>';
			}
			if (data.COLUMNLIST[0].indexOf('HABITAT')> -1) {
				theInnerHtml += '<th>Microhabitat</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MIN_ELEV_IN_M')> -1) {
				theInnerHtml += '<th>Min&nbsp;Elevation&nbsp;(m)</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MAX_ELEV_IN_M')> -1) {
				theInnerHtml += '<th>Max&nbsp;Elevation&nbsp;(m)</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MINIMUM_ELEVATION')> -1) {
				theInnerHtml += '<th>Min&nbsp;Elevation</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MAXIMUM_ELEVATION')> -1) {
				theInnerHtml += '<th>Max&nbsp;Elevation</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ORIG_ELEV_UNITS')> -1) {
				theInnerHtml += '<th>Elevation&nbsp;Units</th>';
			}
			if (data.COLUMNLIST[0].indexOf('SPEC_LOCALITY')> -1) {
				theInnerHtml += '<th>Specific&nbsp;Locality</th>';
			}			
			if (data.COLUMNLIST[0].indexOf('GEOLOGY_ATTRIBUTES')> -1) {
				theInnerHtml += '<th>Geology&nbsp;Attributes</th>';
			}

			if (data.COLUMNLIST[0].indexOf('VERBATIM_DATE')> -1) {
				theInnerHtml += '<th>Verbatim&nbsp;Date</th>';
			}
			if (data.COLUMNLIST[0].indexOf('BEGAN_DATE')> -1) {
				theInnerHtml += '<th>Began&nbsp;Date</th>';
			}
			if (data.COLUMNLIST[0].indexOf('ENDED_DATE')> -1) {
				theInnerHtml += '<th>Ended&nbsp;Date</th>';
			}
			if (data.COLUMNLIST[0].indexOf('YEARCOLL')> -1) {
				theInnerHtml += '<th>Year</th>';
			}
			if (data.COLUMNLIST[0].indexOf('MONCOLL')> -1) {
				theInnerHtml += '<th>Month</th>';
			}
			if (data.COLUMNLIST[0].indexOf('DAYCOLL')> -1) {
				theInnerHtml += '<th>Day</th>';
			}
			if (data.COLUMNLIST[0].indexOf('PARTS')> -1) {
				theInnerHtml += '<th>Parts</th>';
			}
			if (data.COLUMNLIST[0].indexOf('PARTDETAIL')> -1) {
				theInnerHtml += '<th>Part Detail</th>';
			}
			if (data.COLUMNLIST[0].indexOf('SEX')> -1) {
				theInnerHtml += '<th>Sex</th>';
			}
			if (data.COLUMNLIST[0].indexOf('REMARKS')> -1) {
				theInnerHtml += '<th>Specimen&nbsp;Remarks</th>';
			}
			if (data.COLUMNLIST[0].indexOf('COLL_OBJ_DISPOSITION')> -1) {
				theInnerHtml += '<th>Specimen&nbsp;Disposition</th>';
			}
			for (a=0; a<nAtt; a++) {
				if (data.COLUMNLIST[0].indexOf(attAry[a].toUpperCase())> -1) {
					theInnerHtml += '<th>' + attAry[a] + '</th>';
				}
			}
			if (data.COLUMNLIST[0].indexOf('DEC_LAT')> -1) {
				theInnerHtml += '<th>Dec.&nbsp;Lat.</th>';
			}
			if (data.COLUMNLIST[0].indexOf('DEC_LONG')> -1) {
				theInnerHtml += '<th>Dec.&nbsp;Long.</th>';
			}
			if (data.COLUMNLIST[0].indexOf('GREF_COLLNUM') > -1) {
				theInnerHtml += '<th>Gref&nbsp;Link</th>';
			}
		theInnerHtml += '</tr>';
		// get an ordered list of collection_object_ids to pass on to 
		// SpecimenDetail for browsing
		var orderedCollObjIdArray = new Array();		
		for (i=0; i<result.ROWCOUNT; ++i) {
			orderedCollObjIdArray.push(data.COLLECTION_OBJECT_ID[i]);
		}
		var orderedCollObjIdList='';
		if (orderedCollObjIdArray.length < 200) {
			var orderedCollObjIdList = orderedCollObjIdArray.join(",");
		}
            for (i=0; i<result.ROWCOUNT; ++i) {
                orderedCollObjIdArray.push(data.COLLECTION_OBJECT_ID[i]);

                if (i%2) {
                    theInnerHtml += '<tr class="oddRow">';
                } else {
                    theInnerHtml += '<tr class="evenRow">';
                }



                    if (killrow == 1){
                        theInnerHtml += '<td align="center"><input type="checkbox" onchange="toggleKillrow(' + "'";
                        theInnerHtml +=data.COLLECTION_OBJECT_ID[i] + "'" + ',this.checked);"></td>';
                    }
                    theInnerHtml += '<td nowrap="nowrap" id="CatItem_'+data.COLLECTION_OBJECT_ID[i]+'">';
                        theInnerHtml += '<a href="development/Mike-SpecimenDetail.cfm?collection_object_id=';
                        theInnerHtml += data.COLLECTION_OBJECT_ID[i];
                        theInnerHtml += '">';
                        theInnerHtml += data.COLLECTION[i];
                        theInnerHtml += '&nbsp;';
                        theInnerHtml += data.CAT_NUM[i];
                        theInnerHtml += '</a>';
                    theInnerHtml += '</td>';
                    if (loan_request_coll_id.length > 0) {
                        if (loan_request_coll_id == data.COLLECTION_ID[i]){
                            theInnerHtml +='<td><span class="likeLink" onclick="addLoanItem(' + "'";
                            theInnerHtml += data.COLLECTION_OBJECT_ID;
                            theInnerHtml += "');" + '">Request</span></td>';
                        } else {
                            theInnerHtml +='<td>N/A</td>';
                        }
                    }
                    if (action == 'dispCollObj'){
                        theInnerHtml +='<td id="partCell_' + data.COLLECTION_OBJECT_ID[i] + '"></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('CUSTOMID')> -1) {
                        theInnerHtml += '<td>' + data.CUSTOMID[i] + '</td>';
                    }

                    if (data.COLUMNLIST[0].indexOf('MEDIA')> -1) {
                        theInnerHtml += '<td>';
                        theInnerHtml += '<div class="shortThumb"><div class="thumb_spcr">&nbsp;</div>';
                            var thisMedia=JSON.parse(data.MEDIA[i]);
                            for (m=0; m<thisMedia.ROWCOUNT; ++m) {

                                // This is where my media edits begin.

                                /*
                                 Step #1: Obtain the correct item ID number:
                                 thisMedia.DATA.media_uri[m]
                                 Step #2: Obtain the boolean: using IE (T) or not (F).
                                 Step #3: Calculate all correct links.
                                 Step #4: Create the <div> tag, insert links, and format correctly.
                                 Step #4a: Add IE fix if using IE is True.

                                 Image for audio: pURI='images/audioNoThumb.png';
                                 Image for generic: pURI='/images/noThumb.jpg';
                                 */

                                if (thisMedia.DATA.mimecat[m] != 'audio') {

                                    if (thisMedia.DATA.preview_uri[m].length > 0) {
                                        pURI = thisMedia.DATA.preview_uri[m];
                                    } else {
                                        pURI = '/images/noThumb.jpg';
                                    }

                                    theInnerHtml +=
                                        '<div class="one_thumb">' +
                                            '<a href="' + thisMedia.DATA.media_uri[m] + '" target="_blank">' +
                                            '<img src="' + pURI + '" class="theThumb"></a>' +
                                            '<br><br><a target="_blank" href="/media/' + thisMedia.DATA.media_id[m] + '">Media Detail</a>' +
                                            '</div>';

                                } else {

                                    // Do arithmetic.
                                    
                                    wavPlaybackUrl = thisMedia.DATA.media_uri[m],
                                        length = wavPlaybackUrl.split('/').length,
                                        fileName = wavPlaybackUrl.split('/')[length - 1].replace('.wav', ''),
                                        mp3PlaybackUrl = 'http://web.corral.tacc.utexas.edu/MVZ/audio/mp3/' + fileName + '.mp3',
                                        oggPlaybackUrl = 'http://web.corral.tacc.utexas.edu/MVZ/audio/ogg/' + fileName + '.ogg';

                                    // Use when browser isn't IE.
                                    html5 = '<audio preload="auto" autobuffer>' +
                                        '    <source src="' + mp3PlaybackUrl + '" />' +
                                        '    <source src="' + oggPlaybackUrl + '" />' +
                                        '    <source src="' + wavPlaybackUrl + '" />' +
                                        '</audio>';

                                    // Define a smaller audio player.
                                    player = '<div id="player" style="display: ">' +
                                        '<button onClick="document.getElementById(\'audio\').play()">Play</button>' +
                                        '<button onClick="document.getElementById(\'audio\').pause()">Pause</button>' +
                                        '</div>';

                                    // Use when browser is IE.
                                    ieShim = '<ul class="graphic"><li><a href="' + mp3PlaybackUrl + '">' + fileName + '.mp3</a></li></ul>';

                                    // Figure out what the browser is...? Maybe one day.
                                    isUsingInternetExplorer = false;

                                    /* */

                                    // Create an audio thumb.
                                    theInnerHtml += '<div class="audio_thumb" style="vertical-align:middle;">';

                                    // Display the type of media explicitly.
                                    theInnerHtml += thisMedia.DATA.mimecat[m] + ' (' + thisMedia.DATA.mime_type[m] + ')';

                                    // Place the player here now.
                                    theInnerHtml += '<br>' + 'The player goes here.' + '<br>';

                                    // Display all downloads on one line.
                                    theInnerHtml += '<span class="item">Download: <a id="download" href="mp3PlaybackUrl">mp3</a>' +
                                        ' ' + '<a id="download" href="oggPlaybackUrl">ogg</a>' +
                                        ' ' + '<a id="download" href="wavPlaybackUrl">wav</a>' + '.';

                                    // Set up the link to the media detail page.
                                    theInnerHtml +=
                                        '<br><a target="_blank" href="/media/' + thisMedia.DATA.media_id[m] + '">Media Detail</a></div>';

                                    // Image - for now, we don't need it.
//                                    theInnerHtml += '<a href="' + thisMedia.DATA.media_uri[m] + '" target="_blank">' +
//                                        '<img src="/images/audioNoThumb.png" class="theThumb"></a>';
                                }

                            }
                        theInnerHtml += '<div class="thumb_spcr">&nbsp;</div></div>';
                        theInnerHtml += '</td>';
                    }
                    theInnerHtml += '<td>';
                    theInnerHtml += '<span class="browseLink" type="scientific_name" dval="' + encodeURI(data.SCIENTIFIC_NAME[i]) + '">' + spaceStripper(data.SCIENTIFIC_NAME[i]);
                    theInnerHtml += '</span>';
                    theInnerHtml += '</td>';
                    if (data.COLUMNLIST[0].indexOf('ID_SENSU')> -1) {
                        theInnerHtml += '<td>';
                            theInnerHtml += data.ID_SENSU[i];
                        theInnerHtml += '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('SCI_NAME_WITH_AUTH')> -1) {
                        theInnerHtml += '<td>';
                            theInnerHtml += spaceStripper(data.SCI_NAME_WITH_AUTH[i]);
                        theInnerHtml += '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ID_HISTORY')> -1) {
                        theInnerHtml += '<td>';
                            theInnerHtml += data.ID_HISTORY[i];
                        theInnerHtml += '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('CITATIONS')> -1) {
                        theInnerHtml += '<td>';
                            theInnerHtml += data.CITATIONS[i];
                        theInnerHtml += '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('IDENTIFIED_BY')> -1) {
                        theInnerHtml += '<td>' + splitBySemicolon(data.IDENTIFIED_BY[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('PHYLORDER')> -1) {
                        theInnerHtml += '<td>' + data.PHYLORDER[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('FAMILY')> -1) {
                        theInnerHtml += '<td>' + data.FAMILY[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('OTHERCATALOGNUMBERS')> -1) {
                        theInnerHtml += '<td>' + splitBySemicolon(data.OTHERCATALOGNUMBERS[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ACCESSION')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.ACCESSION[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('COLLECTORS')> -1) {
                        theInnerHtml += '<td>' + splitByComma(data.COLLECTORS[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('PREPARATORS')> -1) {
                        theInnerHtml += '<td>' + splitByComma(data.PREPARATORS[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('VERBATIMLATITUDE')> -1) {
                        theInnerHtml += '<td>' + cordFormat(data.VERBATIMLATITUDE[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('VERBATIMLONGITUDE')> -1) {
                        theInnerHtml += '<td>' + cordFormat(data.VERBATIMLONGITUDE[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('COORDINATEUNCERTAINTYINMETERS')> -1) {
                        theInnerHtml += '<td>' + data.COORDINATEUNCERTAINTYINMETERS[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('DATUM')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.DATUM[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ORIG_LAT_LONG_UNITS')> -1) {
                        theInnerHtml += '<td>' + data.ORIG_LAT_LONG_UNITS[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('LAT_LONG_DETERMINER')> -1) {
                        theInnerHtml += '<td>' + splitBySemicolon(data.LAT_LONG_DETERMINER[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('LAT_LONG_REF_SOURCE')> -1) {
                        theInnerHtml += '<td>' + data.LAT_LONG_REF_SOURCE[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('LAT_LONG_REMARKS')> -1) {
                        theInnerHtml += '<td><div class="wrapLong">' + data.LAT_LONG_REMARKS[i] + '</div></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('CONTINENT_OCEAN')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.CONTINENT_OCEAN[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('COUNTRY')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.COUNTRY[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('STATE_PROV')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.STATE_PROV[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('SEA')> -1) {
                        theInnerHtml += '<td>' + data.SEA[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('QUAD')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.QUAD[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('FEATURE')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.FEATURE[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('COUNTY')> -1) {
                        theInnerHtml += '<td>' + data.COUNTY[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ISLAND_GROUP')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.ISLAND_GROUP[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ISLAND')> -1) {
                        theInnerHtml += '<td>' + spaceStripper(data.ISLAND[i]) + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ASSOCIATED_SPECIES')> -1) {
                        theInnerHtml += '<td><div class="wrapLong">' + data.ASSOCIATED_SPECIES[i] + '</div></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('HABITAT')> -1) {
                        theInnerHtml += '<td><div class="wrapLong">' + data.HABITAT[i] + '</div></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('MIN_ELEV_IN_M')> -1) {
                        theInnerHtml += '<td>' + data.MIN_ELEV_IN_M[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('MAX_ELEV_IN_M')> -1) {
                        theInnerHtml += '<td>' + data.MAX_ELEV_IN_M[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('MINIMUM_ELEVATION')> -1) {
                        theInnerHtml += '<td>' + data.MINIMUM_ELEVATION[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('MAXIMUM_ELEVATION')> -1) {
                        theInnerHtml += '<td>' + data.MAXIMUM_ELEVATION[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ORIG_ELEV_UNITS')> -1) {
                        theInnerHtml += '<td>' + data.ORIG_ELEV_UNITS[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('SPEC_LOCALITY')> -1) {
                        theInnerHtml += '<td id="SpecLocality_'+data.COLLECTION_OBJECT_ID[i] + '">';
                        theInnerHtml += '<span class="browseLink" type="spec_locality" dval="' + encodeURI(data.SPEC_LOCALITY[i]) + '"><div class="wrapLong">' + data.SPEC_LOCALITY[i] + '</div>';
                        theInnerHtml += '</span>';
                        theInnerHtml += '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('GEOLOGY_ATTRIBUTES')> -1) {
                        theInnerHtml += '<td>' + data.GEOLOGY_ATTRIBUTES[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('VERBATIM_DATE')> -1) {
                        theInnerHtml += '<td>' + data.VERBATIM_DATE[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('BEGAN_DATE')> -1) {
                        theInnerHtml += '<td>' + data.BEGAN_DATE[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('ENDED_DATE')> -1) {
                        theInnerHtml += '<td>' + data.ENDED_DATE[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('YEARCOLL')> -1) {
                        theInnerHtml += '<td>' + data.YEARCOLL[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('MONCOLL')> -1) {
                        theInnerHtml += '<td>' + data.MONCOLL[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('DAYCOLL')> -1) {
                        theInnerHtml += '<td>' + data.DAYCOLL[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('PARTS')> -1) {
                        theInnerHtml += '<td><div class="wrapLong">' + splitBySemicolon(data.PARTS[i]) + '</div></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('PARTDETAIL')> -1) {
                        theInnerHtml += '<td><div class="wrapLong">' + splitByLF(data.PARTDETAIL[i]) + '</div></td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('SEX')> -1) {
                        theInnerHtml += '<td>' + data.SEX[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('REMARKS')> -1) {
                        theInnerHtml += '<td>' + data.REMARKS[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('COLL_OBJ_DISPOSITION')> -1) {
                        theInnerHtml += '<td>' + data.COLL_OBJ_DISPOSITION[i] + '</td>';
                    }
                    for (a=0; a<nAtt; a++) {
                        if (data.COLUMNLIST[0].indexOf(attAry[a].toUpperCase())> -1) {
                        var attStr='data.' + attAry[a].toUpperCase() + '[' + i + ']';
                            theInnerHtml += '<td>' + eval(attStr) + '</td>';
                        }
                    }
                    if (data.COLUMNLIST[0].indexOf('DEC_LAT')> -1) {
                        theInnerHtml += '<td style="font-size:small">' + data.DEC_LAT[i] + '</td>';
                    }
                    if (data.COLUMNLIST[0].indexOf('DEC_LONG')> -1) {
                        theInnerHtml += '<td style="font-size:small">' + data.DEC_LONG[i] + '</td>';
                    }
                theInnerHtml += '</tr>';
            }
		theInnerHtml += '</table>';		
	    theInnerHtml = theInnerHtml.replace(/<td>null<\/td>/g,"<td>&nbsp;</td>");
	    theInnerHtml = theInnerHtml.replace(/<div class="wrapLong">null<\/div>/g,"&nbsp;");
	    theInnerHtml = theInnerHtml.replace(/<td style="font-size:small">null<\/td>/g,"<td>&nbsp;</td>");


		tgt.innerHTML = theInnerHtml;
		if (action == 'dispCollObj'){
			makePartThingy();
		}
		insertMedia(orderedCollObjIdList);
		insertTypes(orderedCollObjIdList);
	}
}
function ssvar (startrow,maxrows) {
	alert(startrow + ' ' + maxrows);
	var s_startrow = document.getElementById('s_startrow');
	var s_torow = document.getElementById('s_torow');
	s_startrow.innerHTML = startrow;
	s_torow.innerHTML = parseInt(startrow) + parseInt(maxrows) -1;
	jQuery.getJSON("/component/functions.cfc",
		{
			method : "ssvar",
			startrow : startrow,
			maxrows : maxrows,
			returnformat : "json",
			queryformat : 'column'
		},
	success_ssvar
	);
}
function jumpToPage (v) {
	var a = v.split(",");
	var p = a[0];
	var m=a[1];
	ssvar(p,m);
}
function closeCustom() {
	var theDiv = document.getElementById('customDiv');
	document.body.removeChild(theDiv);
	var murl='/SpecimenResults.cfm?' + document.getElementById('mapURL').value;
	window.location=murl;
}
function closeCustomNoRefresh() {
	var theDiv = document.getElementById('customDiv');
	document.body.removeChild(theDiv);	
	var theDiv = document.getElementById('bgDiv');
	document.body.removeChild(theDiv);
}
function logIt(msg,status) {
	var mDiv=document.getElementById('msgs');
	var mhDiv=document.getElementById('msgs_hist');
	var mh=mDiv.innerHTML + '<hr>' + mhDiv.innerHTML;
	mhDiv.innerHTML=mh;
	mDiv.innerHTML=msg;
	if (status==0){
		mDiv.className='error';
	} else {
		mDiv.className='successDiv';
		document.getElementById('oidnum').focus();
		document.getElementById('oidnum').select();
	}
}