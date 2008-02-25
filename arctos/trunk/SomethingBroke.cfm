<cfinclude template="/includes/_header.cfm"
<cfoutput>

 <table cellpadding="10">
	<tr><td valign="top"><img src="/images/oops.gif"></td>
	<td>
    <font color="##FF0000" size="+1"><strong>An error occurred while processing this page!</strong></font>
	<hr>
	<cfset errorDate = dateformat(#error.DateTime#,"dd mmm yyyy")>
	<cfset errorTime = timeformat(#error.DateTime#,"HH:mm ss")>
		<p>#error.Diagnostics#</p>

		<p>Please submit a <a href="/info/bugs.cfm">Bug Report</a> containing any information that may help us solve this problem.</p>
		
		
		
	<!----
	<strong>Time of exception:</strong> #errorTime# on #errorDate#
	<p><strong>Error Message:</strong> #error.Diagnostics#
	</p>
	<p><strong>The page that caused this error was:</strong> #error.Template#
		<cfif len(#error.QueryString#) gt 0>
			?#error.QueryString#
		</cfif>
	<p><strong>Your browser is: </strong> #error.Browser#
	<cfif len(#error.HTTPReferer#) gt 0>
		<p><strong>You came to this page from:</strong> #error.HTTPReferer#
	</cfif>
	<cfif isdefined("cfcatch.sql") and len(#cfcatch.sql#) gt 0>
		Detail: #cfcatch.sql#
	</cfif>
		---->
	<p>This message has been logged. Please submit a <a href="/info/bugs.cfm">bug report</a> 
	with any infomation that might allow us to resolve this problem.</p>
	
	
	
	<cfmail subject="Broken Page" to="#Application.PageProblemEmail#" from="SomethingBroke@#Application.fromEmail#" type="html">
		<!---
		<cfdump var="#error#">
		<cfdump var="#cfcatch#">
		---->
		errorTime: #errorTime#
		<br />errorDate: #errorDate#		
		<br />error.type: #error.type#		
		<br />error.Diagnostics: #error.Diagnostics#
		<cfif isdefined("error.QueryString")>
			<br />error.QueryString: #error.QueryString#
		</cfif>
		<cfif isdefined("cfcatch.sql")>
			<br />cfcatch.sql: #cfcatch.sql#
		</cfif>
		<cfif isdefined("error.Template")>
			<br />error.Template: #error.Template#
		</cfif>
		<cfif isdefined("error.Message")>
			<br />error.Message: #error.Message#
		</cfif>
		<cfif isdefined("cfcatch.Message")>
			<br />cfcatch.Message: #cfcatch.Message#
		</cfif>
		<cfif isdefined("cfcatch.Detail")>
			<br />cfcatch.Detail: #cfcatch.Detail#
		</cfif>
		
		<cfif isdefined("error.Browser")>
			<br />error.Browser: #error.Browser#
		</cfif>
		<cfif isdefined("error.HTTPReferer")>
			<br />error.HTTPReferer: #error.HTTPReferer#
		</cfif>
		<cfif isdefined("client.username")>
			<br />client.username: #client.username#
		</cfif>
		<cfif isdefined("cgi.REMOTE_ADDR")>
			<br />cgi.REMOTE_ADDR: #cgi.REMOTE_ADDR#
		</cfif>
		<br>This message was generated by /SomethingBroke.cfm.
	</cfmail>
</td></tr>
</table>
</cfoutput>
<cfinclude template="/includes/_footer.cfm">