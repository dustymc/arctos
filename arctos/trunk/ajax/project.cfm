<cfoutput>
	<cfquery name="pn" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select project_name from project where upper(project_name) like '%#ucase(q)#%'
		order by project_name
	</cfquery>
	<cfloop query="pn">
		#project_name# #chr(10)#
	</cfloop>
</cfoutput>