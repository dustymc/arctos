<cfinclude template="/includes/_header.cfm">

<cfquery name="pd" datasource="prod">
	select * from temp_chas_mamm
</cfquery>

<cfdump var=#pd#>
<cfquery name="td" datasource="UAM_GOD">
	select * form chas where rownum<10
</cfquery>

<cfdump var=#td#>


<!---------------------------------------------------------------------------------------------------->
<cfinclude template="/includes/_footer.cfm">