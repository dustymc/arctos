<table border cellpadding="0" cellspacing="0" style="background-color:#FFFFFF; position:absolute; top:0px; right:0px; font-size:12px;">
	<tr>
		<td>&nbsp;<a href="/home.cfm" target="_top" class="novisit">Home</a>&nbsp;</td>
		<td>&nbsp;<a href="/login.cfm" target="_top" class="novisit">Preferences</a>&nbsp;</td>
		<td>&nbsp;<a href="javascript:void(0);" onClick="getInstDocs('GENERIC','index')" class="novisit">Help</a>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;<a href="/siteMap.cfm" target="_top" class="novisit">Site Map</a>&nbsp;</td>
		<td>&nbsp;<a href="/user_loan_request.cfm" target="_top" class="novisit">Use Specimens</a>&nbsp;</td>
		<!---<td>&nbsp;<a href="http://www.uaf.edu/museum/af/using.html" target="_top" class="novisit">Contact Us</a>&nbsp;</td>---->
		<td>&nbsp;<a href="/Collections/index.cfm" target="_top" class="novisit">Collections</a>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
		<cfif len(#client.username#) gt 0><a href="/login.cfm?action=signOut" target="_top" class="novisit">
						Log out <cfoutput>#client.username#</cfoutput>
					</a>
				<cfelse><a href="/login.cfm" target="_top" class="novisit">Log in</a></cfif>
		</td>
	</tr>
</table>