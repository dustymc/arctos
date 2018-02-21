<cfinclude template="/includes/_header.cfm">
	<cfset title="attribtue search builder thingee">
	<cfoutput>
		<cfquery name="d" datasource="uam_god">
			select ATTRIBUTE_TYPE from ctattribute_type group by ATTRIBUTE_TYPE order by lower(ATTRIBUTE_TYPE)
		</cfquery>
		<cfquery name="fattrorder" datasource="uam_god">
			select max(DISP_ORDER) mdo from ssrch_field_doc
		</cfquery>
		<cfset n=ceiling(fattrorder.mdo) +1>
		<cfset variables.encoding="UTF-8">
		<cfset variables.f_srch_field_doc="#Application.webDirectory#/download/srch_field_doc.sql">
		<cfset variables.f_ss_doc="#Application.webDirectory#/download/specsrch.txt">
		<cfset x='<!---Autogenerated by /Admin/buildAttributeSearchByNameCode.cfm. Do not manually modify this file.---->' & chr(10)>
		<!---- get all units code tables, plus ass in the stuff we can guess via eg, to_meters function ---->
		<cfset canconvert="M,METERS,METER,FT,FEET,FOOT,KM,KILOMETER,KILOMETERS,MM,MILLIMETER,MILLIMETERS,CM,CENTIMETER,CENTIMETERS,MI,MILE,MILES,YD,YARD,YARDS,FM,FATHOM,FATHOMS">

		<cfquery name="ctlu" datasource="uam_god">
			select length_units from ctlength_units where upper(length_units) not in (#listqualify(canconvert,"'")#) group by length_units
		</cfquery>
		<cfset attrLengthUnits=valuelist(ctlu.length_units)>
		<cfset attrLengthUnits=listappend(attrLengthUnits,canconvert)>




		<cfset canconvert="G,GRAMS,GRAM,KG,KILOGRAM,KILOGRAMS,LB,POUND,POUNDS,OZ,OUNCE,OUNCES">
		<cfquery name="ctwu" datasource="uam_god">
			select weight_units from ctweight_units where upper(weight_units) not in (#listqualify(canconvert,"'")#)  group by weight_units
		</cfquery>
		<cfset attrWeightUnits=valuelist(ctwu.weight_units)>
		<cfset attrWeightUnits=listappend(attrWeightUnits,canconvert)>


		<cfset canconvert="D,DAY,DAYS,H,HOUR,HOURS,M,MONTH,MONTHS,WEEK,WEEKS,YR,YEAR,YEARS">
		<cfquery name="cttu" datasource="uam_god">
			select NUMERIC_AGE_UNITS time_units from CTNUMERIC_AGE_UNITS  where upper(NUMERIC_AGE_UNITS) not in (#listqualify(canconvert,"'")#)  group by NUMERIC_AGE_UNITS
		</cfquery>
		<cfset attrTimeUnits=valuelist(cttu.time_units)>
		<cfset attrTimeUnits=listappend(attrTimeUnits,canconvert)>


		<cfset x=x & chr(10) & '<cfset attrLengthUnits="#attrLengthUnits#">'>
		<cfset x=x & chr(10) & '<cfset attrWeightUnits="#attrWeightUnits#">'>
		<cfset x=x & chr(10) & '<cfset attrTimeUnits="#attrTimeUnits#">'>
		<cfset x=x & chr(10) & '<cfset charattrschops="=,!"><cfset numattrschops="=,!,<,>">' & chr(10)>
		<cfscript>
			variables.josrch_field_doc = createObject('Component', '/component.FileWriter').init(variables.f_srch_field_doc, variables.encoding, 32768);
			variables.josrch_field_doc.writeLine("delete from ssrch_field_doc where CATEGORY='attribute';#chr(10)#");
			variables.f_ss_doc = createObject('Component', '/component.FileWriter').init(variables.f_ss_doc, variables.encoding, 32768);
			variables.f_ss_doc.writeLine(x);
		</cfscript>
		<cfloop query="d">
			<cfquery name="tctl" datasource="uam_god">
				select
					CTATTRIBUTE_TYPE.ATTRIBUTE_TYPE,
					CTATTRIBUTE_TYPE.DESCRIPTION,
					ctattribute_code_tables.VALUE_CODE_TABLE,
					ctattribute_code_tables.UNITS_CODE_TABLE
				from
					CTATTRIBUTE_TYPE,
					ctattribute_code_tables
				where
					CTATTRIBUTE_TYPE.ATTRIBUTE_TYPE=ctattribute_code_tables.ATTRIBUTE_TYPE (+) and
					CTATTRIBUTE_TYPE.ATTRIBUTE_TYPE='#ATTRIBUTE_TYPE#'
				group by
					CTATTRIBUTE_TYPE.ATTRIBUTE_TYPE,
					CTATTRIBUTE_TYPE.DESCRIPTION,
					ctattribute_code_tables.VALUE_CODE_TABLE,
					ctattribute_code_tables.UNITS_CODE_TABLE
			</cfquery>
			<cfset attrvar=lcase(trim(replace(replace(replace(ATTRIBUTE_TYPE,' ','_','all'),'-','_','all'),"/","_","all")))>
			<cfif len(tctl.VALUE_CODE_TABLE) gt 0>
				<!--- categorical ---->
				<cfset srchhint='See code table for vocabulary. Search for underbar (_) to require #ATTRIBUTE_TYPE#. Prefix value with "=" (exact) or "!" (is not).'>
			<cfelseif tctl.UNITS_CODE_TABLE is "ctlength_units">
				<cfset srchhint='Search for underbar (_) to require #ATTRIBUTE_TYPE#. Prefix value with "=","<",">","!" (exact, less than, more than, is not). Suffix with appropriate units.'>
			<cfelseif tctl.UNITS_CODE_TABLE is "ctweight_units">
				<cfset srchhint='Search for underbar (_) to require #ATTRIBUTE_TYPE#. Prefix value with "=","<",">","!" (exact, less than, more than, is not). Suffix with appropriate units.'>
			<cfelseif tctl.UNITS_CODE_TABLE is "ctnumeric_age_units">
				<cfset srchhint='Search for underbar (_) to require #ATTRIBUTE_TYPE#. Prefix value with "=","<",">","!" (exact, less than, more than, is not). Suffix with appropriate units.'>
			<cfelse>
				<!---- free-text - wheeeee..... ---->
				<cfset srchhint='Search for underbar (_) to require #ATTRIBUTE_TYPE#. Prefix value with "=" (exact) or "!" (is not).'>
			</cfif>
<cfset v="insert into ssrch_field_doc (
	CATEGORY,
	CF_VARIABLE,
	CONTROLLED_VOCABULARY,
	DEFINITION,
	DISPLAY_TEXT,
	DOCUMENTATION_LINK,
	PLACEHOLDER_TEXT,
	SEARCH_HINT,
	SQL_ELEMENT,
	SPECIMEN_RESULTS_COL,
	DISP_ORDER,
	SPECIMEN_QUERY_TERM
) values (
	'attribute',
	'#attrvar#',
	'#tctl.VALUE_CODE_TABLE#',
	'#escapeQuotes(tctl.DESCRIPTION)#',
	'#ATTRIBUTE_TYPE#',
	'#Application.docURL#/attributes.html##searching-with-attributes',
	'#ATTRIBUTE_TYPE#',
	'#srchhint#',
	'concatAttributeValue(flatTableName.collection_object_id,''#ATTRIBUTE_TYPE#'')',
	1,
	#n#,
	1
);
">

<cfset n=n+1>
<cfset x='<cfif isdefined("#attrvar#") and len(#attrvar#) gt 0>'>
<cfset x=x & chr(10) & '  <cfset mapurl = "##mapurl##&#attrvar#=###attrvar###">'>
<cfset x=x & chr(10) & '  <cfif compare(#attrvar#,"NULL") is 0>'>
<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND ConcatAttributeValue(flat.collection_object_id,''#attrvar#'') is null">'>
<cfset x=x & chr(10) & '  <cfelse>'>
<cfset x=x & chr(10) & '    <cfset basJoin = " ##basJoin## INNER JOIN v_attributes tbl_#attrvar# ON (##session.flatTableName##.collection_object_id = tbl_#attrvar#.collection_object_id)">'>
<cfset x=x & chr(10) & '    <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_type = ''#ATTRIBUTE_TYPE#''">'>
<cfset x=x & chr(10) & '    <cfif session.flatTableName is not "flat"><cfset basQual = " ##basQual## AND tbl_#attrvar#.is_encumbered = 0"></cfif>'>
<cfset x=x & chr(10) & '    <cfif #attrvar# neq "_">'><!--- if it does, we're done here ---->


<!--- if units-controlled attribute, then ..... ---->
<cfif len(tctl.UNITS_CODE_TABLE) gt 0>

	<!----
		what can happen here:
			x=y -- case-insensitive substring of value
			x==y - case-insensitive string of value
			x=!y - x not like (nocase) y
	---->


	<cfif tctl.UNITS_CODE_TABLE is "ctlength_units">
		<cfset asrchlst="attrLengthUnits">
	<cfelseif tctl.UNITS_CODE_TABLE is "ctweight_units">
		<cfset asrchlst="attrWeightUnits">
	<cfelseif tctl.UNITS_CODE_TABLE is "ctnumeric_age_units">
		<cfset asrchlst="attrTimeUnits">
	<cfelse>
		<cfset asrchlst="'XXXX'">
	</cfif>
	<cfset x=x & chr(10) & '    <cfset schunits="">'>
	<cfset x=x & chr(10) & '    <cfset oper=left(#attrvar#,1)>'>
	<cfset x=x & chr(10) & '    <cfif listfind(numattrschops,oper)>'>
	<cfset x=x & chr(10) & '      <cfset schTerm=ucase(right(#attrvar#,len(#attrvar#)-1))>'>
	<cfset x=x & chr(10) & '    <cfelse>'>
	<cfset x=x & chr(10) & '      <cfset oper="like"><cfset schTerm=ucase(#attrvar#)>'>
	<cfset x=x & chr(10) & '    </cfif>'>
	<cfset x=x & chr(10) & '    <cfif oper is "!"><cfset oper="!="></cfif>'>
	<cfset x=x & chr(10) & '    <cfset temp=trim(rereplace(schTerm,"[0-9]","","all"))>'>
	<cfset x=x & chr(10) & '    <cfif len(temp) gt 0 and listfindnocase(#asrchlst#,temp) and isnumeric(replace(schTerm,temp,""))>'>
	<cfset x=x & chr(10) & '      <cfset schTerm=replace(schTerm,temp,"")><cfset schunits=temp>'>
	<cfset x=x & chr(10) & '    <cfelseif left(temp,1) eq "-" and listfindnocase(attrTimeUnits,trim(replace(temp,"-","")))>'>
	<cfset x=x & chr(10) & '      <cfset schunits=trim(replace(temp,"-",""))>'>
	<cfset x=x & chr(10) & '      <cfset low=trim(listgetat(numeric_age,1,"-"))>'>
	<cfset x=x & chr(10) & '      <cfset high=trim(replacenocase(replace(replace(numeric_age,low,"","first"),"-",""),schunits,""))>'>
	<cfset x=x & chr(10) & '      <cfset schTerm=trim(replace(replace(replace(numeric_age,schunits,""),low,""),high,""))>'>
	<cfset x=x & chr(10) & '      <cfif len(low) gt 0 and len(high) gt 0 and len(schunits) gt 0><cfset oper="between"></cfif>'>
	<cfset x=x & chr(10) & '    </cfif>'>
	<cfif asrchlst is "attrLengthUnits">
		<cfset x=x & chr(10) & '    <cfif oper is "between">'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_days(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_days(##low##,''##schunits##'') and to_days(##high##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelseif len(schunits) gt 0>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_meters(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_meters(##schTerm##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelse>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_value ##oper## ''##schTerm##''">'>
		<cfset x=x & chr(10) & '    </cfif>'>
	<cfelseif asrchlst is "attrWeightUnits">
		<cfset x=x & chr(10) & '    <cfif oper is "between">'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_grams(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_grams(##low##,''##schunits##'') and to_grams(##high##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelseif len(schunits) gt 0>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_grams(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_grams(##schTerm##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelse>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_value ##oper## ''##schTerm##''">'>
		<cfset x=x & chr(10) & '    </cfif>'>
	<cfelseif asrchlst is "attrTimeUnits">
		<cfset x=x & chr(10) & '    <cfif oper is "between">'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_days(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_days(##low##,''##schunits##'') and to_days(##high##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelseif len(schunits) gt 0>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND to_days(tbl_#attrvar#.attribute_value,tbl_#attrvar#.attribute_units) ##oper## to_days(##schTerm##,''##schunits##'')">'>
		<cfset x=x & chr(10) & '    <cfelse>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_value ##oper## ''##schTerm##''">'>
		<cfset x=x & chr(10) & '    </cfif>'>
	<cfelse>
		<cfset x=x & chr(10) & '    <cfif len(schunits) gt 0>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_value ##oper## ##schTerm## and tbl_#attrvar#.attribute_units=''##schunits##'' ">'>
		<cfset x=x & chr(10) & '    <cfelse>'>
		<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND tbl_#attrvar#.attribute_value ##oper## ''##schTerm##''">'>
		<cfset x=x & chr(10) & '    </cfif>'>
	</cfif>
<cfelse>
	<!----
		value code tables and free text have the same handler
		what can happen here:
			x=y -- case-insensitive substring
			x==y - case-insensitive string
			x=!y - x not like (nocase) y
	---->
	<cfset x=x & chr(10) & '    <cfset oper=left(#attrvar#,1)>'>
	<cfset x=x & chr(10) & '    <cfif listfind(charattrschops,oper)>'>
	<cfset x=x & chr(10) & '      <cfset schTerm=ucase(right(#attrvar#,len(#attrvar#)-1))>'>
	<cfset x=x & chr(10) & '    <cfelse>'>
	<cfset x=x & chr(10) & '      <cfset oper="like"><cfset schTerm=ucase(#attrvar#)>'>
	<cfset x=x & chr(10) & '    </cfif>'>
	<cfset x=x & chr(10) & '    <cfif oper is "!"><cfset oper="!="></cfif>'>
	<cfset x=x & chr(10) & '    <cfif oper is "like">'>
	<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND upper(tbl_#attrvar#.attribute_value) ##oper## ''%##ucase(escapeQuotes(schTerm))##%''">'>
	<cfset x=x & chr(10) & '	<cfelse>'>
	<cfset x=x & chr(10) & '      <cfset basQual = " ##basQual## AND upper(tbl_#attrvar#.attribute_value) ##oper## ''##ucase(escapeQuotes(schTerm))##''">'>
	<cfset x=x & chr(10) & '	</cfif>'>
</cfif>
<cfset x=x & chr(10) &  '  </cfif>'>
<cfset x=x & chr(10) &  '</cfif>'>
<cfset x=x & chr(10) & '</cfif>'>

<cfset x=x & chr(10)>
	<cfscript>
		variables.josrch_field_doc.writeLine(v);
		variables.f_ss_doc.writeLine(x);
	</cfscript>
</cfloop>
<cfscript>
	variables.josrch_field_doc.close();
	variables.f_ss_doc.close();
</cfscript>
		This app just builds text.
		<p>
			Get the SQL to update ssrch_field_doc <a href="/download/srch_field_doc.sql">here</a>
		</p>

		<p>
			Get the CFML to build /includes/SearchSql_attributes.cfm <a href="/download/specsrch.txt">here</a>
		</p>

		<p>To avoid strange fractions and gaps, run this, commit, and then reload this page.</p>
<textarea rows="10" cols="100">
declare
  n number;
  begin
    n:=1;
    for r in (select disp_order from ssrch_field_doc where DISP_ORDER is not null order by DISP_ORDER) loop
      update ssrch_field_doc set disp_order=n where disp_order=r.disp_order;
      n:=n+1;
    end loop;
end;
/
</textarea>
	</cfoutput>
<cfinclude template="/includes/_footer.cfm">