<cfinclude template="/includes/_header.cfm">
<script src="/includes/sorttable.js"></script>

<cfset inet_address = CreateObject("java", "java.net.InetAddress")>
<cfoutput>
	<cfparam name="rptprd" default=1>
	<cfparam name="mincount" default=20>
	<form name="f" method="post" action="blacklistattempt.cfm">
		blacklisted_entry_attempt for the last <input type="number" name="rptprd" id="rptprd" value="#rptprd#">
		 days, containining only those subnets originating > <input type="number" name="mincount" id="mincount" value="#mincount#"> attempts
		<input type="submit" value="filter">
	</form>
	<cfquery name="d" datasource="uam_god">
			SELECT
			regexp_replace(ip,'^([0-9]{1,3}\.[0-9]{1,3})\..*$','\1') subnet,
			count(*) attempts
		from
			blacklisted_entry_attempt
			where
			to_char(timestamp,'yyyy-mm-dd') >= sysdate-#rptprd#
		having
			count(*) > #mincount#
		group by
			regexp_replace(ip,'^([0-9]{1,3}\.[0-9]{1,3})\..*$','\1')
		 order by
		 	count(*) DESC
	</cfquery>

	<hr>Subnet-only
	<ul>
		<li>
			Last#rptprd#=number of attempts from the subnet in last #rptprd# days
		</li>
	</ul>
	<table border id="t" class="sortable">
		<tr>
			<th>Subnet</th>
			<th>Last#rptprd#</th>
			<th>Clickypop</th>
		</tr>
		<cfloop query="d">
			<tr>
				<td>#d.subnet#</td>
				<td>#d.attempts#</td>
				<td><a href="blacklistattempt.cfm?rptprd=#rptprd#&mincount=#mincount#&detailsn=#d.subnet#">details</a></td>
			</tr>
		</cfloop>
	</table>
	<cfif isdefined("detailsn") and len(detailsn) gt 0>
		<hr>Details for subnet #detailsn#
		<ul>
			<li>
				Last#rptprd#=number of attempts from the subnet in last #rptprd# days
			</li>
			<li>
				alltime=all-time connection attempts
			</li>
		</ul>

		<table border id="t" class="sortable">
		<tr>
			<th>Subnet</th>
			<th>Last#rptprd#</th>
			<th>alltime</th>
			<th>IP</th>
			<th>Host</th>
			<th>Click</th>
		</tr>
		<cfloop query="d">
			<cfquery name="ips" datasource="uam_god">
				select
					ip,
					count(*) c
				from
					blacklisted_entry_attempt
				where
					ip like '#detailsn#.%'
				group by
					ip
				order by
					count(*) DESC
			</cfquery>
			<cfloop query="#ips#">
				<cftry>
					<cfset host_name = inet_address.getByName("#ip#").getHostName()>
				<cfcatch>
					<cfset host_name='idk'>
				</cfcatch></cftry>
				<tr>
					<td>#d.subnet#</td>
					<td>#d.attempts#</td>
					<td>#c#</td>
					<td>#ip#</td>
					<td>#host_name#</td>
					<td><a target="_blanl" class="external" href="http://whatismyipaddress.com/ip/#ip#">lookup</a></td>
				</tr>
			</cfloop>
		</cfloop>
	</table>


	</cfif>

<!------------
	<hr>
	Including IPs



	---------->
</cfoutput>
<cfinclude template="/includes/_footer.cfm">