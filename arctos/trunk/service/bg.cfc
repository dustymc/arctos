<cfcomponent>
	<cfoutput>
		<cffunction name="bg" access="remote" returntype="Any" output="true">
			<cfhttp url="http://bg.berkeley.edu/latest" charset="utf-8" method="get" name="bg">
			</cfhttp>
	  	</cffunction>
	</cfoutput>
</cfcomponent>